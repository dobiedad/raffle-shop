# frozen_string_literal: true

require 'test_helper'

class RafflesControllerTest < ActionDispatch::IntegrationTest
  test '#index' do
    get raffles_url

    assert_response :success

    Raffle.order(created_at: :desc).limit(6).find_each do |raffle|
      assert_text raffle.name
    end
  end

  test '#index with search query' do
    raffle = raffles(:iphone_giveaway)

    get raffles_url, params: { q: { name_cont: 'iPhone' }, category: 'tech' }

    assert_response :success
    assert_text raffle.name
    assert_select '.button.is-active', text: 'Tech'
  end

  test '#index pagination' do
    15.times do
      Raffle.create!(valid_raffle_params.merge(user: users(:bob)))
    end

    get raffles_url

    assert_response :success
    assert_select '.pagination'
  end

  test '#show' do
    get raffle_url(iphone_giveaway)

    assert_response :success
  end

  test '#new' do
    login_as bob
    get new_raffle_url

    assert_response :success
  end

  test '#new requires authentication ' do
    get new_raffle_url

    assert_redirected_to new_user_session_url
  end

  test '#create' do
    login_as bob

    assert_difference('Raffle.count') do
      post raffles_url, params: {
        raffle: valid_raffle_params
      }
    end

    assert_redirected_to raffle_url(Raffle.last)
  end

  test '#create fails' do
    login_as bob

    assert_no_difference('Raffle.count') do
      post raffles_url, params: {
        raffle: valid_raffle_params.merge(name: nil)
      }
    end

    assert_response :unprocessable_entity
    assert_text "Name can't be blank"
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
      condition: 'Good',
      end_date: 7.days.from_now
    }
  end
end
