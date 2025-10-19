# frozen_string_literal: true

require 'test_helper'

class FeedControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated' do
    get feed_path

    assert_redirected_to new_user_session_url
  end

  test 'should show feed when authenticated' do
    login_as leo

    get feed_path

    assert_response :success
  end

  test 'shows activity from followed users' do
    login_as leo
    leo.follow!(bob)

    get feed_path

    assert_response :success
  end

  test 'shows empty state when not following anyone' do
    # Create a new user who doesn't follow anyone
    new_user = User.create!(email: 'newuser@test.com', password: 'password123')
    login_as new_user

    get feed_path

    assert_response :success
    assert_select 'p', text: /Recent activity from people you follow/
  end
end
