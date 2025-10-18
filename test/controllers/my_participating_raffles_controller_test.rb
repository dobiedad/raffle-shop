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

  test '#index shows raffles user is participating in' do
    login_as bob
    raffle = raffles(:iphone_giveaway)
    bob.wallet.update!(balance: 1000)
    raffle.buy_tickets(buyer: bob, quantity: 1)

    get my_participating_raffles_url

    assert_response :success
    assert_text raffle.name
  end

  test '#index with status=completed shows only completed raffles user participated in' do
    login_as bob
    bob.wallet.update!(balance: 10_000)

    active_raffle = Raffle.create!(valid_raffle_params.merge(user: users(:leo), name: 'Active Test'))
    completed_raffle = Raffle.create!(valid_raffle_params.merge(user: users(:leo), status: :completed,
                                                                completed_at: 1.day.ago, name: 'Completed Test'))
    cancelled_raffle = Raffle.create!(valid_raffle_params.merge(user: users(:leo), status: :cancelled,
                                                                completed_at: 2.days.ago, name: 'Cancelled Test'))

    active_raffle.buy_tickets(buyer: bob, quantity: 1)
    bob.raffle_tickets.create!(raffle: completed_raffle, price: completed_raffle.ticket_price, purchased_at: 2.days.ago)
    bob.raffle_tickets.create!(raffle: cancelled_raffle, price: cancelled_raffle.ticket_price, purchased_at: 3.days.ago)

    get my_participating_raffles_url, params: { status: 'completed' }

    assert_response :success
    assert_text completed_raffle.name
    assert_text cancelled_raffle.name
    assert_no_text active_raffle.name
  end

  test '#index with status=active shows only active raffles user is participating in' do
    login_as bob
    bob.wallet.update!(balance: 10_000)

    active_raffle = Raffle.create!(valid_raffle_params.merge(user: users(:leo), name: 'Active Test'))
    completed_raffle = Raffle.create!(valid_raffle_params.merge(user: users(:leo), status: :completed,
                                                                completed_at: 1.day.ago, name: 'Completed Test'))

    active_raffle.buy_tickets(buyer: bob, quantity: 1)
    bob.raffle_tickets.create!(raffle: completed_raffle, price: completed_raffle.ticket_price, purchased_at: 2.days.ago)

    get my_participating_raffles_url, params: { status: 'active' }

    assert_response :success
    assert_text active_raffle.name
    assert_no_text completed_raffle.name
  end

  test '#index defaults to active status' do
    login_as bob
    bob.wallet.update!(balance: 10_000)

    active_raffle = Raffle.create!(valid_raffle_params.merge(user: users(:leo), name: 'Active Test'))
    completed_raffle = Raffle.create!(valid_raffle_params.merge(user: users(:leo), status: :completed,
                                                                completed_at: 1.day.ago, name: 'Completed Test'))

    active_raffle.buy_tickets(buyer: bob, quantity: 1)
    bob.raffle_tickets.create!(raffle: completed_raffle, price: completed_raffle.ticket_price, purchased_at: 2.days.ago)

    get my_participating_raffles_url

    assert_response :success
    assert_text active_raffle.name
    assert_no_text completed_raffle.name
  end

  test '#index with status=completed shows won raffles' do
    login_as bob
    bob.wallet.update!(balance: 10_000)

    won_raffle = Raffle.create!(valid_raffle_params.merge(
                                  user: users(:leo),
                                  status: :completed,
                                  completed_at: 1.day.ago,
                                  winner_id: bob.id,
                                  drawn_at: 1.day.ago,
                                  name: 'Won Raffle'
                                ))
    bob.raffle_tickets.create!(raffle: won_raffle, price: won_raffle.ticket_price, purchased_at: 2.days.ago)

    get my_participating_raffles_url, params: { status: 'completed' }

    assert_response :success
    assert_text won_raffle.name
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
