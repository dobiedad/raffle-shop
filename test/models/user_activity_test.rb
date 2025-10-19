# frozen_string_literal: true

require 'test_helper'

class UserActivityTest < ActiveSupport::TestCase
  test 'validates presence of activity_type' do
    activity = UserActivity.new(user: leo, subject: raffles(:iphone_giveaway))

    assert_not activity.valid?
    assert_includes activity.errors[:activity_type], "can't be blank"
  end

  test 'validates activity_type inclusion' do
    activity = UserActivity.new(user: leo, subject: raffles(:iphone_giveaway), activity_type: 'invalid_type')

    assert_not activity.valid?
    assert_includes activity.errors[:activity_type], 'is not included in the list'
  end

  test 'belongs to user' do
    activity = user_activities(:leo_created_iphone)

    assert_equal leo, activity.user
  end

  test 'belongs to subject polymorphically' do
    activity = user_activities(:leo_created_iphone)

    assert_equal raffles(:iphone_giveaway), activity.subject
  end

  test '.create_raffle_activity creates activity' do
    raffle = raffles(:iphone_giveaway)

    assert_difference 'UserActivity.count', 1 do
      UserActivity.create_raffle_activity(leo, raffle)
    end

    activity = UserActivity.last

    assert_equal 'created_raffle', activity.activity_type
    assert_equal leo, activity.user
    assert_equal raffle, activity.subject
  end

  test '.create_entry_activity creates activity' do
    raffle = raffles(:apple_watch_series_10)

    assert_difference 'UserActivity.count', 1 do
      UserActivity.create_entry_activity(bob, raffle)
    end

    activity = UserActivity.last

    assert_equal 'entered_raffle', activity.activity_type
    assert_equal bob, activity.user
    assert_equal raffle, activity.subject
  end

  test '.create_entry_activity does not create duplicate' do
    raffle = raffles(:iphone_giveaway)
    UserActivity.create_entry_activity(bob, raffle)

    assert_no_difference 'UserActivity.count' do
      UserActivity.create_entry_activity(bob, raffle)
    end
  end

  test '.create_win_activity creates activity' do
    raffle = raffles(:iphone_giveaway)

    assert_difference 'UserActivity.count', 1 do
      UserActivity.create_win_activity(bob, raffle)
    end

    activity = UserActivity.last

    assert_equal 'won_raffle', activity.activity_type
    assert_equal bob, activity.user
    assert_equal raffle, activity.subject
  end

  test '.create_follow_activity creates activity' do
    followed_user = users(:jane)

    assert_difference 'UserActivity.count', 1 do
      UserActivity.create_follow_activity(leo, followed_user)
    end

    activity = UserActivity.last

    assert_equal 'followed_user', activity.activity_type
    assert_equal leo, activity.user
    assert_equal followed_user, activity.subject
  end

  test '.recent scope orders by created_at desc' do
    activities = UserActivity.recent.limit(2)

    assert_operator activities.first.created_at, :>=, activities.second.created_at
  end

  test '.by_type scope filters by activity_type' do
    activities = UserActivity.by_type('created_raffle')

    assert(activities.all? { |a| a.activity_type == 'created_raffle' })
  end

  test '.for_users scope filters by user_ids' do
    activities = UserActivity.for_users([leo.id])

    assert(activities.all? { |a| a.user_id == leo.id })
  end
end
