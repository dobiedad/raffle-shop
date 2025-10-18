# frozen_string_literal: true

require 'test_helper'

class MyCreatedRafflesControllerTest < ActionDispatch::IntegrationTest
  test '#index' do
    login_as bob
    get my_created_raffles_url

    assert_response :success
    assert_text '🎫 My Raffles'
    assert_text 'Manage your created raffles and track raffles you\'re participating in'
  end

  test '#index shows user created raffles' do
    login_as bob
    raffle = Raffle.create!(valid_raffle_params.merge(user: bob))

    get my_created_raffles_url

    assert_response :success
    assert_text raffle.name
  end

  test '#index pagination' do
    login_as bob
    8.times do
      Raffle.create!(valid_raffle_params.merge(user: bob))
    end

    get my_created_raffles_url

    assert_response :success
    assert_select '.pagination'
  end

  test '#index requires authentication' do
    get my_created_raffles_url

    assert_redirected_to new_user_session_url
  end

  test '#index only shows current user raffles' do
    login_as bob
    other_user = users(:leo)

    Raffle.create!(valid_raffle_params.merge(user: other_user))

    user_raffle = Raffle.create!(valid_raffle_params.merge(user: bob))

    get my_created_raffles_url

    assert_response :success
    assert_text user_raffle.name
  end

  test '#index with status=completed shows only completed raffles' do
    login_as bob
    active_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, name: 'Active Test'))
    completed_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, status: :completed, completed_at: 1.day.ago, name: 'Completed Test'))
    cancelled_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, status: :cancelled, completed_at: 2.days.ago, name: 'Cancelled Test'))

    get my_created_raffles_url, params: { status: 'completed' }

    assert_response :success
    assert_text completed_raffle.name
    assert_text cancelled_raffle.name
    assert_no_text active_raffle.name
  end

  test '#index with status=active shows only active raffles' do
    login_as bob
    active_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, name: 'Active Test'))
    completed_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, status: :completed, completed_at: 1.day.ago, name: 'Completed Test'))

    get my_created_raffles_url, params: { status: 'active' }

    assert_response :success
    assert_text active_raffle.name
    assert_no_text completed_raffle.name
  end

  test '#index defaults to active status' do
    login_as bob
    active_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, name: 'Active Test'))
    completed_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, status: :completed, completed_at: 1.day.ago, name: 'Completed Test'))

    get my_created_raffles_url

    assert_response :success
    assert_text active_raffle.name
    assert_no_text completed_raffle.name
  end

  private

  def valid_raffle_params
    {
      name: 'BMW X6',
      general_description: 'My Beloved BMW X6, 2012 100k Miles',
      condition_description: 'Recently serviced',
      whats_included_description: '2 Keys',
      price: 50_000,
      ticket_price: 25.0,
      category: 'vehicles',
      condition: 'good',
      end_date: 7.days.from_now
    }
  end
end
