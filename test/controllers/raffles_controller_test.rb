# frozen_string_literal: true

require 'test_helper'

class RafflesControllerTest < ActionDispatch::IntegrationTest
  test '#index' do
    get raffles_url

    assert_response :success

    Raffle.find_each do |raffle|
      assert_text raffle.name
    end
  end

  test '#index with search query' do
    raffle = raffles(:iphone_giveaway)

    get raffles_url, params: { search: 'iPhone' }

    assert_response :success
    assert_text raffle.name
  end

  test '#index with category filter' do
    # Test category filtering
    get raffles_url, params: { category: 'Tech' }

    assert_response :success
    assert_select '.button.is-active', text: 'Tech'
  end

  test '#index pagination' do
    # Create more than 9 raffles to test pagination
    15.times do |i|
      Raffle.create!(
        name: "Test Raffle #{i}",
        description: "Description #{i}",
        price: 100,
        ticket_price: 5,
        category: 'Tech',
        condition: 'New',
        end_date: 7.days.from_now,
        user: users(:leo)
      )
    end

    get raffles_url

    assert_response :success
    # Should see pagination controls
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
      description: 'My Beloved BMW X6, 2012 100k Miles',
      price: 50_000,
      ticket_price: 25.0,
      category: 'Vehicles',
      condition: 'Good',
      end_date: 7.days.from_now
    }
  end
end
