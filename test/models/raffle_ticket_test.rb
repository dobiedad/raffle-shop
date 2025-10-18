# frozen_string_literal: true

require 'test_helper'

class RaffleTicketTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", 'is not a number', price: nil
    assert_invalid "can't be blank", purchased_at: nil
    assert_invalid 'must be greater than 0', price: -1
  end

  test '#ticket_number is the hashid uppercased' do
    ticket = raffle_tickets(:bob_rolex_ticket)

    assert_equal ticket.hashid.upcase, ticket.ticket_number
  end
end
