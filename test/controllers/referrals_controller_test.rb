# frozen_string_literal: true

require 'test_helper'

class ReferralsControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to sign in when not authenticated' do
    get referrals_url

    assert_redirected_to new_user_session_url
  end

  test 'should show referrals page when authenticated' do
    login_as leo

    get referrals_url

    assert_response :success
    assert_select 'h1', text: 'Referral Rewards'
    assert_select '.title', text: /How Referrals Work/
    assert_select '.title', text: /Your Referral Code/
  end

  test 'should display referral code on referrals page' do
    login_as leo

    get referrals_url

    assert_response :success
    assert_select 'code', text: leo.referral_code
  end

  test 'should display referral stats' do
    login_as leo

    get referrals_url

    assert_response :success
    assert_select 'p', text: /Total Referrals/
    assert_select 'p', text: /Free Tickets Earned/
    assert_select 'p', text: /Value Earned/
  end

  test 'should display referred users when user has referrals' do
    # Create a referred user
    referred_user = User.create!(
      first_name: 'Referred',
      last_name: 'User',
      email: 'referred@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      referred_by: leo
    )

    login_as leo

    get referrals_url

    assert_response :success
    assert_select '.title', text: /Your Referred Users/
    assert_select 'h4', text: referred_user.full_name
  end

  test 'should display empty state when user has no referrals' do
    # Ensure leo has no referrals
    leo.referred_users.destroy_all

    login_as leo

    get referrals_url

    assert_response :success
    assert_select '.title', text: /No Referrals Yet/
  end

  test 'should calculate correct referral stats' do
    # Create referred users with different ticket counts
    referred_user1 = User.create!(
      first_name: 'User',
      last_name: 'One',
      email: 'user1@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      referred_by: leo
    )

    referred_user2 = User.create!(
      first_name: 'User',
      last_name: 'Two',
      email: 'user2@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      referred_by: leo
    )

    # Create some raffle tickets for the referred users
    raffle = raffles(:iphone_giveaway)
    3.times do
      RaffleTicket.create!(user: referred_user1, raffle: raffle, price: 1.0, purchased_at: Time.current)
    end

    7.times do
      RaffleTicket.create!(user: referred_user2, raffle: raffle, price: 1.0, purchased_at: Time.current)
    end

    login_as leo

    get referrals_url

    assert_response :success
    # Should show 2 total referrals
    assert_select '.title', text: '2'
    # Should show 10 total tickets earned (3 + 7, both under the 10 ticket limit)
    assert_select '.title', text: '10'
  end

  test 'should limit ticket rewards to first 10 per user' do
    # Create a referred user
    referred_user = User.create!(
      first_name: 'Heavy',
      last_name: 'User',
      email: 'heavy@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      referred_by: leo
    )

    # Create 15 raffle tickets (should only count first 10)
    raffle = raffles(:iphone_giveaway)
    15.times do
      RaffleTicket.create!(user: referred_user, raffle: raffle, price: 1.0, purchased_at: Time.current)
    end

    login_as leo

    get referrals_url

    assert_response :success
    # Should show 10 tickets earned (limited to first 10)
    assert_select '.title', text: '10'
  end

  test 'should display copy link button' do
    login_as leo

    get referrals_url

    assert_response :success
    assert_select 'button[data-controller="copy"]', text: /Copy Link/
  end

  test 'should display back to profile link' do
    login_as leo

    get referrals_url

    assert_response :success
    assert_select 'a[href=?]', profile_path, text: /Back to Profile/
  end
end
