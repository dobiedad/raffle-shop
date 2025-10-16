# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated' do
    get profile_url

    assert_redirected_to new_user_session_url
  end

  test 'should show profile when authenticated' do
    login_as users(:leo)

    get profile_url

    assert_response :success
    assert_select 'h1', text: users(:leo).email
    assert_select '.title', text: /Tickets Entered/
    assert_select '.title', text: /Total Spent/
    assert_select '.title', text: /Raffles Won/
  end

  test 'should display stats on profile' do
    login_as users(:leo)

    get profile_url

    assert_response :success
    assert_select '.box', minimum: 5
  end

  test 'should have edit profile link' do
    login_as users(:leo)

    get profile_url

    assert_response :success
    assert_select 'a[href=?]', edit_user_registration_path, text: 'Edit Profile'
  end
end
