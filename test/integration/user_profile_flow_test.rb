# frozen_string_literal: true

require 'test_helper'

class UserProfileFlowTest < ActionDispatch::IntegrationTest
  test 'user can navigate from profile to edit and back' do
    login_as users(:leo)

    get profile_url

    assert_response :success

    get edit_user_registration_url

    assert_response :success
    assert_select 'h1', text: 'Edit Profile'

    assert_select 'a[href=?]', profile_path, text: 'Profile'
  end

  test 'user can view their profile stats' do
    login_as users(:leo)

    get profile_url

    assert_response :success
    assert_select '.box', minimum: 5
    assert_select 'h2', text: /Tickets Entered/
    assert_select 'h2', text: /Total Spent/
    assert_select 'h2', text: /Raffles Won/
    assert_select 'h2', text: /Wallet Balance/
    assert_select 'h2', text: /Achievements/
  end
end
