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
