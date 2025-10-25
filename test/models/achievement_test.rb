# frozen_string_literal: true

require 'test_helper'

class AchievementTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", name: nil
    assert_invalid "can't be blank", description: nil
    assert_invalid "can't be blank", icon: nil
    assert_invalid "can't be blank", color: nil
  end

  test 'user_meets_criteria for first_win' do
    achievement = AchievementsRegistry.find_by_name(:first_win)
    user = leo

    user.stubs(:raffles_won).returns(stub(one?: true))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for trusted_user' do
    achievement = AchievementsRegistry.find_by_name(:trusted_user)
    user = leo

    user.stubs(:raffles).returns(stub(count: 6))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for early_adopter' do
    achievement = AchievementsRegistry.find_by_name(:early_adopter)
    user = leo

    user.stubs(:days_since_registration).returns(35)

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for big_spender' do
    achievement = AchievementsRegistry.find_by_name(:big_spender)
    user = leo

    user.stubs(:raffle_tickets).returns(stub(sum: 15_000))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for hot_streak' do
    achievement = AchievementsRegistry.find_by_name(:hot_streak)
    user = leo

    user.stubs(:consecutive_wins_count).returns(5)

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for ticket_collector' do
    achievement = AchievementsRegistry.find_by_name(:ticket_collector)
    user = leo

    user.stubs(:raffle_tickets).returns(stub(count: 60))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for lucky_winner' do
    achievement = AchievementsRegistry.find_by_name(:lucky_winner)
    user = leo

    user.stubs(:raffles_won).returns(stub(count: 5))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for raffle_master' do
    achievement = AchievementsRegistry.find_by_name(:raffle_master)
    user = leo

    user.stubs(:raffles).returns(stub(count: 12))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for high_roller' do
    achievement = AchievementsRegistry.find_by_name(:high_roller)
    user = leo

    user.stubs(:raffle_tickets).returns(stub(sum: 60_000))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for popular' do
    achievement = AchievementsRegistry.find_by_name(:popular)
    user = leo

    user.stubs(:followers).returns(stub(count: 30))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for veteran' do
    achievement = AchievementsRegistry.find_by_name(:veteran)
    user = leo

    user.stubs(:days_since_registration).returns(100)

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria for ticket_master' do
    achievement = AchievementsRegistry.find_by_name(:ticket_master)
    user = leo

    user.stubs(:raffle_tickets).returns(stub(count: 120))

    assert achievement.user_meets_criteria?(user)
  end

  test 'user_meets_criteria returns false for invalid achievement' do
    achievement = Achievement.new(
      name: :invalid_achievement,
      description: 'Invalid',
      icon: '❌',
      color: 'is-danger'
    )
    user = leo

    assert_not achievement.user_meets_criteria?(user)
  end

  test 'display_name humanizes name' do
    achievement = AchievementsRegistry.find_by_name(:first_win)

    assert_equal '🏆 First win', achievement.display_name
  end


end
