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

  test 'increments followings_count on follower' do
    assert_difference 'leo.reload.followings_count', 1 do
      Follow.create!(follower: leo, followed: bob)
    end
  end

  test 'increments followers_count on followed' do
    assert_difference 'bob.reload.followers_count', 1 do
      Follow.create!(follower: leo, followed: bob)
    end
  end

  test 'decrements followings_count on follower when destroyed' do
    follow = Follow.create!(follower: leo, followed: bob)

    assert_difference 'leo.reload.followings_count', -1 do
      follow.destroy
    end
  end

  test 'decrements followers_count on followed when destroyed' do
    follow = Follow.create!(follower: leo, followed: bob)

    assert_difference 'bob.reload.followers_count', -1 do
      follow.destroy
    end
  end

  test 'belongs to follower' do
    follow = Follow.create!(follower: leo, followed: bob)

    assert_equal leo, follow.follower
  end

  test 'belongs to followed' do
    follow = Follow.create!(follower: leo, followed: bob)

    assert_equal bob, follow.followed
  end
end
