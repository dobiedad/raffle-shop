# frozen_string_literal: true

require 'test_helper'

class FollowsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated for create' do
    post follow_user_path(bob)

    assert_redirected_to new_user_session_url
  end

  test 'should redirect to sign in when not authenticated for destroy' do
    delete unfollow_user_path(bob)

    assert_redirected_to new_user_session_url
  end

  test '#create follows user' do
    login_as leo

    assert_difference 'Follow.count', 1 do
      post follow_user_path(bob)
    end

    assert leo.reload.following?(bob)
  end

  test '#create redirects with HTML request' do
    login_as leo

    post follow_user_path(bob)

    assert_response :redirect
  end

  test '#create responds to turbo_stream' do
    login_as leo

    post follow_user_path(bob), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html; charset=utf-8', response.content_type
  end

  test '#destroy unfollows user' do
    login_as leo
    leo.follow!(bob)

    assert_difference 'Follow.count', -1 do
      delete unfollow_user_path(bob)
    end

    assert_not leo.reload.following?(bob)
  end

  test '#destroy redirects with HTML request' do
    login_as leo
    leo.follow!(bob)

    delete unfollow_user_path(bob)

    assert_response :redirect
  end

  test '#destroy responds to turbo_stream' do
    login_as leo
    leo.follow!(bob)

    delete unfollow_user_path(bob), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

    assert_response :success
    assert_equal 'text/vnd.turbo-stream.html; charset=utf-8', response.content_type
  end

  test '#create handles already following gracefully' do
    login_as leo
    leo.follow!(bob)

    assert_no_difference 'Follow.count' do
      post follow_user_path(bob)
    end

    assert_response :redirect
  end

  test '#destroy does nothing when not following' do
    login_as leo

    assert_no_difference 'Follow.count' do
      delete unfollow_user_path(bob)
    end

    assert_not leo.reload.following?(bob)
  end
end
