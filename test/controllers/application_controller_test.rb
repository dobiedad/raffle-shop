# frozen_string_literal: true

require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test 'stores location and redirects back after login for protected pages' do
    get feed_path

    assert_redirected_to new_user_session_url

    post user_session_path, params: {
      user: { email: 'leo@test.com', password: 'password123' }
    }

    assert_redirected_to feed_path
  end
end
