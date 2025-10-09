# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", email: nil
  end
end
