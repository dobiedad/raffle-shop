# frozen_string_literal: true

require 'application_system_test_case'

class UserProfileTest < ApplicationSystemTestCase
  test 'user can navigate from profile to edit and back' do
    login_as(leo)

    visit profile_path

    assert_text leo.full_name
    click_link 'Edit Profile'

    assert_text 'Edit Profile'
    assert_selector "a[href=\"#{profile_path}\"]"
  end

  test 'user can view their profile stats' do
    login_as(leo)

    visit profile_path

    assert_text 'Tickets Entered'
    assert_text 'Total Spent'
    assert_text 'Raffles Won'
    assert_text 'Wallet Balance'
    assert_text 'Achievements'
  end
end
