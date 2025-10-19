# frozen_string_literal: true

require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  test 'validates presence of follower' do
    follow = Follow.new(follower: nil, followed: bob)

    assert_not follow.valid?
    assert_includes follow.errors[:follower], 'must exist'
  end

  test 'validates presence of followed' do
    follow = Follow.new(follower: leo, followed: nil)

    assert_not follow.valid?
    assert_includes follow.errors[:followed], 'must exist'
  end

  test 'validates uniqueness of follower_id scoped to followed_id' do
    Follow.create!(follower: leo, followed: bob)

    duplicate_follow = Follow.new(follower: leo, followed: bob)

    assert_not duplicate_follow.valid?
    assert_includes duplicate_follow.errors[:follower_id], 'has already been taken'
  end

  test 'prevents self-follow' do
    self_follow = Follow.new(follower: leo, followed: leo)

    assert_not self_follow.valid?
    assert_includes self_follow.errors[:follower_id], 'cannot follow yourself'
  end
end
