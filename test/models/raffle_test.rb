# frozen_string_literal: true

require 'test_helper'

class RaffleTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", name: nil
    assert_invalid "can't be blank", description: nil
    assert_invalid "can't be blank", 'is not a number', price: nil
    assert_invalid "can't be blank", 'is not a number', ticket_price: nil
    assert_invalid 'must be greater than 0', price: 0
    assert_invalid 'must be greater than 2', ticket_price: 0
    assert_invalid 'must be less than 100', ticket_price: 101
  end
end
