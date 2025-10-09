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
      price: 50_000
    }
  end
end
