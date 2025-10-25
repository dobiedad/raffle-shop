# frozen_string_literal: true

class Achievement
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name
  attribute :description
  attribute :icon
  attribute :color
  attribute :active, default: true

  validates :name, :description, :icon, :color, presence: true

  def self.check_and_award_achievements(user)
    AchievementsRegistry.active.each do |achievement|
      next if user.achievement?(achievement)
      next unless achievement.user_meets_criteria?(user)

      user.award_achievement!(achievement)
    end
  end

  def user_meets_criteria?(user)
    case name
    when :first_win
      user.raffles_won.one?
    when :trusted_user
      user.raffles.count >= 5
    when :early_adopter
      user.days_since_registration >= 30
    when :big_spender
      user.raffle_tickets.sum(:price) >= 10_000
    when :hot_streak
      user.consecutive_wins_count >= 3
    when :ticket_collector
      user.raffle_tickets.count >= 50
    when :lucky_winner
      user.raffles_won.count >= 3
    when :raffle_master
      user.raffles.count >= 10
    when :high_roller
      user.raffle_tickets.sum(:price) >= 50_000
    when :popular
      user.followers.count >= 25
    when :veteran
      user.days_since_registration >= 90
    when :ticket_master
      user.raffle_tickets.count >= 100
    else
      false
    end
  end

  def display_name
    "#{icon} #{name.to_s.humanize}"
  end
end
