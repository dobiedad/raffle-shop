# frozen_string_literal: true

class RaffleTicket < ApplicationRecord
  include Hashid::Rails

  belongs_to :raffle
  belongs_to :user
  belongs_to :referred_user, class_name: 'User', optional: true
  has_one :purchase_transaction, class_name: 'Transaction', as: :related, dependent: :nullify

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :purchased_at, presence: true

  scope :purchased, -> { where(referred_user: nil) }
  scope :referral_rewards, -> { where.not(referred_user: nil) }

  def ticket_number
    hashid.upcase
  end
end
