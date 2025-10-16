# frozen_string_literal: true

require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'user_avatar_url returns placeholder URL' do
    user = users(:leo)
    url = user_avatar_url(user)

    assert_includes url, 'pravatar.cc'
    assert_match(/img=\d+/, url)
  end

  test 'render_achievements shows achievement badges' do
    user = users(:leo)

    html = render_achievements(user)

    assert_includes html, 'First Win'
    assert_includes html, '10+ Tickets'
    assert_includes html, 'Trusted User'
    assert_includes html, 'Early Adopter'
    assert_includes html, 'Big Spender'
    assert_includes html, 'Hot Streak'
  end
end
