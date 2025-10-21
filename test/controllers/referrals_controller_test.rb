# frozen_string_literal: true

require 'test_helper'

class ReferralsControllerTest < ActionDispatch::IntegrationTest
  test '#index redirects to sign in when not authenticated' do
    get referrals_url

    assert_redirected_to new_user_session_url
  end

  test '#index when authenticated' do
    login_as leo

    get referrals_url

    assert_response :success
    assert_select 'h1', text: 'Referral Rewards'
    assert_select '.title', text: /How Referrals Work/
    assert_select '.title', text: /Your Referral Code/
  end
end
