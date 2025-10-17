# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", email: nil
  end

  test 'creates wallet after user creation' do
    user = User.create!(email: 'newuser@example.com', password: 'password123')

    assert_not_nil user.wallet
    assert_equal 0, user.wallet.balance
  end

  test 'has one wallet' do
    user = leo

    assert_respond_to user, :wallet
    assert_instance_of Wallet, user.wallet
  end

  test 'has many raffle_tickets' do
    user = leo

    assert_respond_to user, :raffle_tickets
  end

  test 'has many raffles_entered through raffle_tickets' do
    user = leo

    assert_respond_to user, :raffles_entered
  end

  test 'has many raffles_won' do
    user = leo

    assert_respond_to user, :raffles_won
  end

  test 'delegates balance to wallet' do
    user = leo
    user.wallet.update!(balance: 100.0)

    assert_in_delta(100.0, user.balance)
  end
end
