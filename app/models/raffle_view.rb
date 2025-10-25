# frozen_string_literal: true

class RaffleView < ApplicationRecord
  belongs_to :raffle
  belongs_to :user, optional: true

  validates :viewed_at, presence: true

  scope :today, -> { where(viewed_at: Date.current.all_day) }
  scope :unique_users_today, lambda {
    today.select('DISTINCT ON (raffle_id, COALESCE(user_id, ip_address)) raffle_id, user_id, ip_address, viewed_at')
  }

  def self.track_view(raffle:, user: nil, ip_address: nil, user_agent: nil)
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
         .select('DISTINCT ON (COALESCE(user_id, ip_address)) *')
         .count
  end
end
