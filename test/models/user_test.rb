# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", email: nil
    assert_invalid "can't be blank", first_name: nil
    assert_invalid "can't be blank", last_name: nil
  end

  test 'creates wallet after user creation' do
    user = User.create!(first_name: 'New', last_name: 'User', email: 'newuser@example.com', password: 'password123')

    assert_not_nil user.wallet
    assert_equal 0, user.wallet.balance
  end

  test 'has one wallet' do
    user = leo

    assert_respond_to user, :wallet
    assert_instance_of Wallet, user.wallet
  end

  test 'has many raffle_tickets' do
    user = leo

    assert_respond_to user, :raffle_tickets
  end

  test 'has many raffles_entered through raffle_tickets' do
    user = leo

    assert_respond_to user, :raffles_entered
  end

  test 'has many raffles_won' do
    user = leo

    assert_respond_to user, :raffles_won
  end

  test 'delegates balance to wallet' do
    user = leo
    user.wallet.update!(balance: 100.0)

    assert_in_delta(100.0, user.balance)
  end

  test 'has many following' do
    leo.follow!(bob)
    leo.follow!(jane)

    assert_equal 2, leo.followings.count
    assert_includes leo.followings, bob
    assert_includes leo.followings, jane
  end

  test 'has many followers' do
    bob.follow!(leo)
    jane.follow!(leo)

    assert_equal 2, leo.followers.count
    assert_includes leo.followers, bob
    assert_includes leo.followers, jane
  end

  test '#following? returns true when following' do
    leo.follow!(bob)

    assert leo.following?(bob)
  end

  test '#following? returns false when not following' do
    assert_not leo.following?(bob)
  end

  test '#follow! creates a follow relationship' do
    assert_difference 'Follow.count', 1 do
      leo.follow!(bob)
    end

    assert leo.following?(bob)
  end

  test '#follow! returns false when trying to follow self' do
    assert_no_difference 'Follow.count' do
      result = leo.follow!(leo)

      assert_not result
    end
  end

  test '#follow! returns false when duplicate' do
    leo.follow!(bob)

    assert_not leo.follow!(bob)
  end

  test '#unfollow! removes follow relationship' do
    leo.follow!(bob)

    assert_difference 'Follow.count', -1 do
      leo.unfollow!(bob)
    end

    assert_not leo.following?(bob)
  end

  test 'destroying user destroys follows as follower' do
    # When destroying a user, both their active and passive follows are destroyed
    total_follows = leo.active_follows.count + leo.passive_follows.count

    assert_difference 'Follow.count', -total_follows do
      leo.destroy
    end
  end

  test 'destroying user destroys follows as followed' do
    new_user = User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com', password: 'password123')
    bob.follow!(new_user)
    jane.follow!(new_user)

    assert_difference 'Follow.count', -2 do
      new_user.destroy
    end
  end
end
