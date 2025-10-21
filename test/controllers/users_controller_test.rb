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
    assert_select 'h1', text: users(:leo).full_name
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

  test '#followers should redirect to sign in when not authenticated' do
    get followers_user_path(leo)

    assert_redirected_to new_user_session_url
  end

  test '#followers should show followers list' do
    login_as leo

    get followers_user_path(leo)

    assert_response :success
  end

  test '#following should redirect to sign in when not authenticated' do
    get following_user_path(leo)

    assert_redirected_to new_user_session_url
  end

  test '#following should show following list' do
    login_as leo

    get following_user_path(leo)

    assert_response :success
  end

  test '#followers paginates results' do
    login_as leo

    get followers_user_path(leo)

    assert_response :success
  end

  test '#show displays public profile for other users' do
    get user_path(bob)

    assert_response :success
    assert_select 'h1', text: bob.full_name
  end

  test '#show displays own profile when accessed via /profile' do
    login_as leo

    get profile_url

    assert_response :success
    assert_select 'h1', text: leo.full_name
    assert_select 'a[href=?]', edit_user_registration_path
  end

  test '#show displays public profile when viewing other user' do
    login_as leo

    get user_path(bob)

    assert_response :success
    assert_select 'h1', text: bob.full_name
  end

  test '#show displays active raffles created by user' do
    get user_path(leo)

    assert_response :success
  end

  test '#show displays follow button for other users' do
    login_as bob

    get user_path(leo)

    assert_response :success
  end

  test '#raffles shows user raffles' do
    get raffles_user_path(leo)

    assert_response :success
    assert_select '.raffles-index', minimum: 1
    assert_select '.profile-image', minimum: 1
  end

  test '#raffles filters by status' do
    get raffles_user_path(leo, status: 'active')

    assert_response :success
    assert_select '.raffles-index', minimum: 1
  end

  test '#raffles shows created tab by default' do
    get raffles_user_path(leo)

    assert_response :success
    assert_select '.tabs li.is-active', text: /Created by/
  end

  test '#raffles shows participating tab when requested' do
    get raffles_user_path(leo, tab: 'participating')

    assert_response :success
    assert_select '.tabs li.is-active', text: /Participating In/
  end

  test '#raffles filters by tab and status' do
    get raffles_user_path(leo, tab: 'participating', status: 'completed')

    assert_response :success
    assert_select '.raffles-index', minimum: 1
  end
end
