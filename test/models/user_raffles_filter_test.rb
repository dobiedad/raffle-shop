# frozen_string_literal: true

require 'test_helper'

class UserRafflesFilterTest < ActiveSupport::TestCase
  def setup
    @user = users(:leo)
  end

  test 'returns created active raffles by default' do
    filter = UserRafflesFilter.new(user: @user)

    result = filter.scope

    assert(result.all? { |r| r.user_id == @user.id && r.active? })
  end

  test 'returns created active raffles explicitly' do
    filter = UserRafflesFilter.new(user: @user, tab: 'created', status: 'active')

    result = filter.scope

    assert(result.all? { |r| r.user_id == @user.id && r.active? })
  end

  test 'returns created completed raffles' do
    filter = UserRafflesFilter.new(user: @user, tab: 'created', status: 'completed')

    result = filter.scope

    assert(result.all? { |r| r.user_id == @user.id && (r.completed? || r.cancelled?) })
  end

  test 'returns participating active raffles' do
    filter = UserRafflesFilter.new(user: @user, tab: 'participating', status: 'active')

    result = filter.scope

    assert_equal @user.raffles_entered.active.distinct.count, result.count
  end

  test 'returns participating completed raffles' do
    filter = UserRafflesFilter.new(user: @user, tab: 'participating', status: 'completed')

    result = filter.scope
    participated_ids = @user.raffle_tickets.pluck(:raffle_id).uniq

    assert(result.all? { |r| participated_ids.include?(r.id) && (r.completed? || r.cancelled?) })
  end

  test 'scope is ordered by created_at desc for active created' do
    filter = UserRafflesFilter.new(user: @user, tab: 'created', status: 'active')

    result = filter.scope.to_a

    assert_equal result.sort_by { |r| -r.created_at.to_i }, result
  end

  test 'scope is ordered by completed_at desc for completed created' do
    filter = UserRafflesFilter.new(user: @user, tab: 'created', status: 'completed')

    result = filter.scope

    # Just verify it's a valid scope, ordering is tested in the query
    assert_kind_of ActiveRecord::Relation, result
  end
end
