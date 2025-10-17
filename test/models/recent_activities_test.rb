# frozen_string_literal: true

require 'test_helper'

class RecentActivitiesTest < ActiveSupport::TestCase
  test '.build builds activities' do
    leo.wallet.add(100_000.0, 'Test deposit', transaction_type: :deposit)

    # TODO: add a fixture where someone has won a raffle already
    assert dyson_comb.buy_ticket(buyer: leo, quantity: dyson_comb.max_tickets)
    dyson_comb.draw_winner!

    recent_activities = RecentActivities.build(leo)

    assert_not_empty recent_activities.activities
  end

  test 'activities include transaction icons' do
    leo.wallet.add(100.0, 'Test deposit', transaction_type: :deposit)

    recent_activities = RecentActivities.build(leo)

    assert(recent_activities.activities.any? { |a| a[:description].include?('💳') })
  end
end
