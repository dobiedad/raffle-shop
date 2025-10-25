# frozen_string_literal: true

require 'test_helper'

class UserAchievementTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid 'must exist', user: nil
    assert_invalid "can't be blank", achievement_name: nil
    assert_invalid "can't be blank", earned_at: nil
  end

  test 'validates user_id uniqueness scoped to achievement_name' do
    existing_user_achievement = user_achievements(:leo_first_win)
    user_achievement = UserAchievement.new(
      user: existing_user_achievement.user,
      achievement_name: existing_user_achievement.achievement_name,
      earned_at: Time.current
    )

    assert_not user_achievement.valid?
    assert_includes user_achievement.errors[:user_id], 'has already been taken'
  end

  test 'belongs to user' do
    user_achievement = user_achievements(:leo_first_win)

    assert_respond_to user_achievement, :user
    assert_instance_of User, user_achievement.user
  end

  test 'achievement method returns achievement from registry' do
    user_achievement = user_achievements(:leo_first_win)

    assert_respond_to user_achievement, :achievement
    assert_instance_of Achievement, user_achievement.achievement
    assert_equal :first_win, user_achievement.achievement.name
  end

  test 'display_name delegates to achievement' do
    user_achievement = user_achievements(:leo_first_win)

    assert_equal user_achievement.achievement.display_name, user_achievement.display_name
  end

  test 'earned_time_ago returns time ago in words' do
    user_achievement = user_achievements(:leo_first_win)

    assert_includes user_achievement.earned_time_ago, 'day'
  end
end
