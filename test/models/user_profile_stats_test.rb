# frozen_string_literal: true

require 'test_helper'

class UserProfileStatsTest < ActiveSupport::TestCase
  def setup
    @user = users(:leo)
    @viewer = users(:bob)
  end

  test 'calculates tickets entered count' do
    stats = UserProfileStats.new(user: @user, viewing_user: @viewer)

    assert_equal @user.raffle_tickets.count, stats.tickets_entered_count
  end

  test 'calculates total spent' do
    stats = UserProfileStats.new(user: @user, viewing_user: @viewer)

    assert_equal @user.raffle_tickets.sum(:price), stats.total_spent
  end

  test 'calculates raffles won count' do
    stats = UserProfileStats.new(user: @user, viewing_user: @viewer)

    assert_equal @user.raffles_won.count, stats.raffles_won_count
  end

  test 'returns wallet balance for own profile' do
    stats = UserProfileStats.new(user: @user, viewing_user: @user)

    assert_not_nil stats.wallet_balance
    assert_equal @user.wallet&.balance || 0, stats.wallet_balance
  end

  test 'returns nil wallet balance for public profile' do
    stats = UserProfileStats.new(user: @user, viewing_user: @viewer)

    assert_nil stats.wallet_balance
  end

  test 'identifies own profile' do
    stats = UserProfileStats.new(user: @user, viewing_user: @user)

    assert_predicate stats, :own_profile?
  end

  test 'identifies public profile' do
    stats = UserProfileStats.new(user: @user, viewing_user: @viewer)

    assert_not stats.own_profile?
  end

  test 'returns recent activities' do
    stats = UserProfileStats.new(user: @user, viewing_user: @viewer)

    assert_instance_of Array, stats.recent_activities
  end
end
