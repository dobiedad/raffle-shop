# frozen_string_literal: true

class Raffle < ApplicationRecord # rubocop:disable Metrics/ClassLength
  belongs_to :user
  belongs_to :winner, class_name: 'User', optional: true, inverse_of: :raffles_won
  has_many :raffle_tickets, dependent: :destroy
  has_many :ticket_holders, through: :raffle_tickets, source: :user
  has_many :raffle_views, dependent: :destroy
  has_many_attached :images
  has_rich_text :general_description
  has_rich_text :condition_description
  has_rich_text :whats_included_description
  has_rich_text :extra_description

  CATEGORIES = %w[tech gaming fashion home vehicles other].freeze
  CONDITIONS = %w[new like_new good fair].freeze
  PLATFORM_FEE_PERCENTAGE = 20

  enum :status, { active: 'active', completed: 'completed', cancelled: 'cancelled' }, default: :active
  enum :category, CATEGORIES.index_by(&:itself)
  enum :condition, CONDITIONS.index_by(&:itself), suffix: true

  validates :name, :general_description, :condition_description, :whats_included_description, :price, :ticket_price,
            :status, :category, :condition, presence: true
  # TODO: rename price to target price or something better
  validates :price, numericality: { greater_than: 0 }
  # TODO: do we actually want a max ticket price of 100 ?
  validates :ticket_price, numericality: { greater_than: 2, less_than: 100 }
  validates :end_date, comparison: { greater_than: -> { Time.current } }, allow_nil: true, on: :create
  validates :platform_fee_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :images,
            content_type: { in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
                            message: 'must be a JPEG, PNG, GIF, or WebP' },
            size: { less_than: 10.megabytes,
                    message: 'must be less than 10MB' },
            limit: { max: 10,
                     message: 'cannot be more than 10 images' }

  after_initialize -> { self.platform_fee_percent = PLATFORM_FEE_PERCENTAGE }, if: :new_record?
  after_create :create_raffle_activity

  attr_readonly :platform_fee_percent, :ticket_price

  # TODO: remvoe this, we dont care about this scope. What we care about is ones that have gone past end date, as
  # other ones end automatically when last ticekt is purchased.
  scope :eligible_for_draw, lambda {
    left_joins(:raffle_tickets)
      .where(status: 'active', winner_id: nil)
      .group(:id)
      .having(<<~SQL.squish, Time.current)
        COUNT(raffle_tickets.id) FILTER (WHERE raffle_tickets.referred_user_id IS NULL) >= CEIL((raffles.price * (1 + (raffles.platform_fee_percent / 100.0))) / raffles.ticket_price)
        OR raffles.end_date <= ?
      SQL
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name category price ticket_price created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end

  def buy_tickets(buyer:, quantity: 1) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return false unless can_actually_buy_tickets?(buyer: buyer, quantity: quantity)

    ActiveRecord::Base.transaction do
      tickets = Array.new(quantity) do
        raffle_tickets.create!(
          user: buyer,
          price: ticket_price,
          purchased_at: Time.current
        )
      end

      ticket_numbers = tickets.map(&:ticket_number).join(', ')
      description = if quantity == 1
                      "#{name} - Ticket ##{ticket_numbers}"
                    else
                      "#{name} - #{quantity} tickets (##{ticket_numbers})"
                    end

      buyer.wallet.deduct(ticket_price * quantity, description, transaction_type: :ticket_purchase)

      UserActivity.create_entry_activity(buyer, self)

      award_referral_ticket!(buyer)

      tickets
    end
  end

  def draw_winner!
    raise 'Raffle is not eligible for draw' unless eligible_for_draw?

    ActiveRecord::Base.transaction do
      unless enough_tickets_sold?
        cancel_and_refund!
        return nil
      end

      winning_ticket = raffle_tickets.order('RANDOM()').first
      update!(
        winner: winning_ticket.user,
        drawn_at: Time.current,
        completed_at: Time.current,
        status: :completed
      )

      distribute_funds!
      create_win_activity
      winner
    end
  end

  def eligible_for_draw?
    return false unless active?
    return false if winner.present?

    Time.current >= end_date || enough_tickets_sold?
  end

  def tickets_sold_count
    raffle_tickets.purchased.count
  end

  def tickets_remaining
    [max_tickets - tickets_sold_count, 0].max
  end

  def amount_raised
    raffle_tickets.purchased.sum(:price)
  end

  def days_remaining
    return nil if end_date.nil?

    [(end_date.to_date - Date.current).to_i, 0].max
  end

  def max_tickets
    ((price * (1 + (platform_fee_percent.to_f / 100))) / ticket_price).ceil
  end

  def enough_tickets_sold?
    raffle_tickets.purchased.count >= max_tickets
  end

  private

  def can_actually_buy_tickets?(buyer:, quantity: 1) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    return add_buy_error('Quantity must be greater than 0') if quantity.nil? || quantity.zero? || quantity.negative?
    return add_buy_error('Insufficient funds') unless buyer.wallet.sufficient_funds?(ticket_price * quantity)
    return add_buy_error('Raffle is no longer active') unless active?
    return add_buy_error('Maximum amount of tickets have already been bought') if tickets_sold_count >= max_tickets
    return add_buy_error('You cannot buy a ticket for your own raffle') if user == buyer

    true
  end

  def add_buy_error(error_message) # rubocop:disable Naming/PredicateMethod
    errors.add(:base, error_message)
    false
  end

  def award_referral_ticket!(buyer)
    return if buyer.referred_by.blank?
    return unless buyer.referred_by.can_receive_referral_reward?(self)

    raffle_tickets.create!(
      user: buyer.referred_by,
      price: ticket_price,
      purchased_at: Time.current,
      referred_user: buyer
    )
  end

  def cancel_and_refund!
    raffle_tickets.purchased.find_each do |ticket|
      ticket.user.wallet.add(
        ticket.price,
        "Refund for ticket ##{ticket.ticket_number} - raffle cancelled: #{name}",
        transaction_type: :refund
      )
    end

    self.status = :cancelled
    self.completed_at = Time.current
    save!
  end

  def distribute_funds!
    return if winner.nil?

    user.wallet.add(
      price,
      "Payout for raffle: #{name}",
      transaction_type: :seller_payout
    )
  end

  def create_raffle_activity
    UserActivity.create_raffle_activity(user, self)
  end

  def create_win_activity
    return if winner.blank?

    UserActivity.create_win_activity(winner, self)
  end
end
