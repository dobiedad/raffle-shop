# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'user_avatar_url returns placeholder URL' do
    # Create a user without a profile image
    user = User.create!(
      first_name: 'Test',
      last_name: 'User',
      email: 'test@example.com',
      password: 'password123',
      referral_code: 'TEST123'
    )

    url = user_avatar_url(user)

    assert_includes url, 'pravatar.cc'
    assert_match(/img=\d+/, url)
  end

  test 'render_achievements shows achievement badges' do
    user = users(:leo)

    html = render_achievements(user)

    assert_includes html, 'First win'
    assert_includes html, 'tag is-success is-light' # First Win should be green
    assert_includes html, '🏆' # First Win icon
  end
end
