# frozen_string_literal: true

class UserAchievement < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: { scope: :achievement_name }
  validates :achievement_name, :earned_at, presence: true

  scope :recent, -> { order(earned_at: :desc) }
  scope :by_achievement, ->(achievement) { where(achievement_name: achievement.name) }

  def achievement
    return @achievement if defined?(@achievement)

    @achievement = AchievementsRegistry.find_by_name(achievement_name.to_sym)
  end

  def display_name
    achievement&.display_name || achievement_name.to_s.humanize
  end

  def earned_time_ago
    ActionController::Base.helpers.time_ago_in_words(earned_at)
  end
end
