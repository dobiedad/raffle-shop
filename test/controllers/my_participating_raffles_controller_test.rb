# frozen_string_literal: true

require 'test_helper'

class MyParticipatingRafflesControllerTest < ActionDispatch::IntegrationTest
  test '#index' do
    login_as bob
    get my_participating_raffles_url

    assert_response :success
    assert_text '🎫 My Raffles'
    assert_text 'Manage your created raffles and track raffles you\'re participating in'
  end

  test '#index shows other users raffles' do
    login_as bob
    # Use existing fixture raffle from leo
    raffle = raffles(:iphone_giveaway)

    get my_participating_raffles_url

    assert_response :success
    # Check that some raffle names are present (since random ordering)
    assert_select '.raffle-card', minimum: 1
  end

  test '#index excludes current user raffles' do
    login_as bob
    user_raffle = Raffle.create!(valid_raffle_params.merge(user: bob, name: 'Bob\'s Raffle'))
    # Use existing fixture raffle from leo
    other_raffle = raffles(:iphone_giveaway)

    get my_participating_raffles_url

    assert_response :success
    assert_text other_raffle.name
    assert_no_text user_raffle.name
  end

  test '#index shows empty state when no other raffles' do
    login_as bob
    # Clear all existing raffles and create only one for current user
    Raffle.destroy_all
    Raffle.create!(valid_raffle_params.merge(user: bob))

    get my_participating_raffles_url

    assert_response :success
    assert_text 'You\'re not participating in any raffles yet'
    assert_text 'Browse Raffles'
  end

  test '#index pagination' do
    login_as bob
    other_user = users(:leo)
    
    # Create 8 raffles for other user
    8.times do |i|
      Raffle.create!(valid_raffle_params.merge(
        user: other_user,
        name: "Raffle #{i + 1}"
      ))
    end

    get my_participating_raffles_url

    assert_response :success
    assert_select '.pagination'
  end

  test '#index requires authentication' do
    get my_participating_raffles_url

    assert_redirected_to new_user_session_url
  end

  test '#index shows badge on raffle cards' do
    login_as bob
    other_user = users(:leo)
    Raffle.create!(valid_raffle_params.merge(user: other_user))

    get my_participating_raffles_url

    assert_response :success
    assert_select '.raffle-badge'
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
