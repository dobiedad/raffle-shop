# frozen_string_literal: true

require 'test_helper'

class WalletsControllerTest < ActionDispatch::IntegrationTest
  test '#show' do
    login_as bob

    get wallet_url

    assert_response :success
  end
end
