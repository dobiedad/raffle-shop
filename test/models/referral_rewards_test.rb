# frozen_string_literal: true

require 'test_helper'

class ReferralRewardsTest < ActiveSupport::TestCase
  test 'awards free ticket to referrer when referred user buys ticket' do
    referred_user = create_referred_user(referred_by: leo)
    raffle = raffles(:iphone_giveaway)

    assert_difference -> { leo.referral_reward_tickets.count }, 1 do
      raffle.buy_tickets(buyer: referred_user, quantity: 1)
    end

    referral_ticket = leo.referral_reward_tickets.last

    assert_equal leo, referral_ticket.user
    assert_equal raffle, referral_ticket.raffle
    assert_equal referred_user, referral_ticket.referred_user
    assert_equal raffle.ticket_price, referral_ticket.price
  end

  test 'only awards one free ticket per raffle per referred user' do
    referred_user = create_referred_user(referred_by: leo)
    raffle = raffles(:iphone_giveaway)

    raffle.buy_tickets(buyer: referred_user, quantity: 1)

    assert_no_difference -> { leo.referral_reward_tickets.count } do
      raffle.buy_tickets(buyer: referred_user, quantity: 1)
    end
  end

  test 'stops awarding free tickets after 10 total across all raffles' do
    referred_user = create_referred_user(referred_by: leo)

    10.times do
      RaffleTicket.create!(
        raffle: raffles(:iphone_giveaway),
        user: leo,
        referred_user: referred_user,
        price: raffles(:iphone_giveaway).ticket_price,
        purchased_at: Time.current
      )
    end

    assert_equal 10, leo.referral_reward_tickets.count

    new_raffle = create_raffle

    assert_no_difference -> { leo.referral_reward_tickets.count } do
      new_raffle.buy_tickets(buyer: referred_user, quantity: 1)
    end
  end

  test 'does not award free ticket if user was not referred' do
    raffle = raffles(:iphone_giveaway)

    assert_no_difference -> { RaffleTicket.referral_rewards.count } do
      raffle.buy_tickets(buyer: jane, quantity: 1)
    end
  end

  test 'free tickets do not count towards raffle max tickets' do
    referred_user = create_referred_user(referred_by: leo)
    raffle = raffles(:iphone_giveaway)
    initial_sold = raffle.tickets_sold_count

    raffle.buy_tickets(buyer: referred_user, quantity: 1)

    assert_equal initial_sold + 1, raffle.tickets_sold_count
    assert_equal initial_sold + 2, raffle.raffle_tickets.count
  end

  test 'free tickets are included in winner draw' do
    referred_user = create_referred_user(referred_by: leo)
    raffle = raffles(:iphone_giveaway)

    raffle.buy_tickets(buyer: referred_user, quantity: 1)

    purchased_tickets = raffle.raffle_tickets.purchased
    free_tickets = raffle.raffle_tickets.referral_rewards

    assert_equal 1, purchased_tickets.count
    assert_equal 1, free_tickets.count
    assert_equal referred_user, purchased_tickets.first.user
    assert_equal leo, free_tickets.first.user
    assert_equal referred_user, free_tickets.first.referred_user
  end

  test 'free tickets are not refunded when raffle is cancelled' do
    referred_user = create_referred_user(referred_by: leo)
    raffle = raffles(:iphone_giveaway)

    raffle.buy_tickets(buyer: referred_user, quantity: 1)

    initial_balance = referred_user.wallet.balance

    raffle.send(:cancel_and_refund!)
    referred_user.wallet.reload

    assert_equal initial_balance + raffle.ticket_price, referred_user.wallet.balance
  end

  test '#can_receive_referral_reward? returns true for eligible referrer' do
    raffle = raffles(:iphone_giveaway)

    assert leo.can_receive_referral_reward?(raffle)
  end

  test '#can_receive_referral_reward? returns false if already received for raffle' do
    referred_user = create_referred_user(referred_by: leo)
    raffle = raffles(:iphone_giveaway)

    raffle.buy_tickets(buyer: referred_user, quantity: 1)

    assert_not leo.can_receive_referral_reward?(raffle)
  end

  test '#can_receive_referral_reward? returns false after 10 total free tickets' do
    referred_user = create_referred_user(referred_by: leo)

    10.times do
      RaffleTicket.create!(
        raffle: raffles(:iphone_giveaway),
        user: leo,
        referred_user: referred_user,
        price: raffles(:iphone_giveaway).ticket_price,
        purchased_at: Time.current
      )
    end

    new_raffle = create_raffle

    assert_not leo.can_receive_referral_reward?(new_raffle)
  end

  private

  def create_referred_user(referred_by:)
    user = User.create!(
      first_name: 'Referred',
      last_name: 'User',
      email: "referred#{SecureRandom.hex(4)}@example.com",
      password: 'password123',
      password_confirmation: 'password123',
      referred_by: referred_by
    )
    user.wallet.add(1000, 'Test funds', transaction_type: :deposit)
    user
  end

  def create_raffle
    raffle = Raffle.new(
      name: "Test Raffle #{SecureRandom.hex(4)}",
      price: 100,
      ticket_price: 5,
      user: bob,
      status: :active,
      category: 'tech',
      condition: 'new',
      end_date: 1.week.from_now
    )
    raffle.general_description = 'Test description'
    raffle.condition_description = 'Test condition'
    raffle.whats_included_description = 'Test included'
    raffle.save!
    raffle
  end
end
