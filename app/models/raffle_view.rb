# frozen_string_literal: true

class RaffleView < ApplicationRecord
  belongs_to :raffle
  belongs_to :user, optional: true

  validates :viewed_at, presence: true

  scope :today, -> { where(viewed_at: Date.current.all_day) }
  scope :unique_users_today, lambda { |raffle = nil|
    scope = today
    scope = scope.where(raffle: raffle) if raffle
    scope.distinct.pluck(:raffle_id, :user_id, :ip_address)
  }

  def self.track_view(raffle:, user: nil, ip_address: nil, user_agent: nil)
    # Only track one view per user/IP per day to avoid spam
    existing_view = where(raffle: raffle, user: user, ip_address: ip_address)
                    .where(viewed_at: Date.current.all_day)
                    .first

    return existing_view if existing_view

    create!(
      raffle: raffle,
      user: user,
      ip_address: ip_address,
      user_agent: user_agent,
      viewed_at: Time.current
    )
  end

  def self.unique_viewers_today(raffle)
    today.where(raffle: raffle)
         .distinct
         .pluck(:user_id, :ip_address)
         .uniq
         .count
  end
end
