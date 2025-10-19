# frozen_string_literal: true

class UserActivity < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true

  ACTIVITY_TYPES = %w[created_raffle entered_raffle won_raffle followed_user].freeze

  validates :activity_type, presence: true, inclusion: { in: ACTIVITY_TYPES }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(activity_type: type) }
  scope :for_users, ->(user_ids) { where(user_id: user_ids) }

  def self.create_raffle_activity(user, raffle)
    create!(
      user: user,
      activity_type: 'created_raffle',
      subject: raffle
    )
  end

  def self.create_entry_activity(user, raffle)
    find_or_create_by!(
      user: user,
      activity_type: 'entered_raffle',
      subject: raffle
    )
  end

  def self.create_win_activity(user, raffle)
    create!(
      user: user,
      activity_type: 'won_raffle',
      subject: raffle
    )
  end

  def self.create_follow_activity(user, followed_user)
    create!(
      user: user,
      activity_type: 'followed_user',
      subject: followed_user
    )
  end
end
