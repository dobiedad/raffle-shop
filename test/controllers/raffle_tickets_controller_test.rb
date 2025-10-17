# frozen_string_literal: true

require 'test_helper'

class RaffleTicketsControllerTest < ActionDispatch::IntegrationTest
  test '#index' do
    login_as bob

    get my_tickets_url

    assert_response :success
  end

  test '#create' do
    login_as bob
    bob.wallet.update!(balance: 100)

    assert_difference('RaffleTicket.count', 1) do
      post raffle_raffle_tickets_url(iphone_giveaway), params: { quantity: 1 }
    end

    assert_redirected_to raffle_url(iphone_giveaway)
  end

  test '#create fails' do
    login_as bob
    bob.wallet.update!(balance: 100)

    assert_no_difference('RaffleTicket.count') do
      post raffle_raffle_tickets_url(iphone_giveaway), params: { quantity: 0 }
    end

    assert_response :redirect
    follow_redirect!

    assert_text 'Quantity must be greater than 0'
  end
end
