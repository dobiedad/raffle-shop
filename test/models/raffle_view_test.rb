# frozen_string_literal: true

require 'test_helper'

class RaffleViewTest < ActiveSupport::TestCase
  test 'belongs to raffle' do
    raffle_view = raffle_views(:iphone_view)

    assert_equal raffles(:iphone_giveaway), raffle_view.raffle
  end

  test 'belongs to user optionally' do
    raffle_view_with_user = raffle_views(:iphone_view)
    raffle_view_without_user = RaffleView.create!(
      raffle: raffles(:iphone_giveaway),
      viewed_at: Time.current,
      ip_address: '192.168.1.1'
    )

    assert_equal users(:leo), raffle_view_with_user.user
    assert_nil raffle_view_without_user.user
  end

  test 'validates viewed_at presence' do
    raffle_view = RaffleView.new(
      raffle: raffles(:iphone_giveaway),
      user: users(:leo)
    )

    assert_not raffle_view.valid?
    assert_includes raffle_view.errors[:viewed_at], "can't be blank"
  end

  test 'today scope returns views from today' do
    today_view = RaffleView.create!(
      raffle: raffles(:iphone_giveaway),
      user: users(:leo),
      viewed_at: Time.current
    )

    yesterday_view = RaffleView.create!(
      raffle: raffles(:iphone_giveaway),
      user: users(:bob),
      viewed_at: 1.day.ago
    )

    today_views = RaffleView.today

    assert_includes today_views, today_view
    assert_not_includes today_views, yesterday_view
  end

  test 'unique_users_today scope returns distinct users and IPs' do
    # Create multiple views from same user/IP (should be deduplicated)
    RaffleView.create!(
      raffle: raffles(:dyson_comb),
      user: users(:leo),
      viewed_at: Time.current,
      ip_address: '192.168.1.1'
    )

    RaffleView.create!(
      raffle: raffles(:dyson_comb),
      user: users(:leo),
      viewed_at: Time.current + 1.hour,
      ip_address: '192.168.1.1'
    )

    # Create view from different user
    RaffleView.create!(
      raffle: raffles(:dyson_comb),
      user: users(:bob),
      viewed_at: Time.current,
      ip_address: '192.168.1.2'
    )

    # Create anonymous view from different IP
    RaffleView.create!(
      raffle: raffles(:dyson_comb),
      viewed_at: Time.current,
      ip_address: '192.168.1.3'
    )

    unique_views = RaffleView.unique_users_today(raffles(:dyson_comb))

    # Should have 3 unique combinations: leo+IP1, bob+IP2, anonymous+IP3
    assert_equal 3, unique_views.count
  end

  test 'track_view creates new view when none exists' do
    raffle = raffles(:dyson_comb)  # Use a different raffle to avoid fixture conflicts
    user = users(:bob)

    assert_difference 'RaffleView.count', 1 do
      view = RaffleView.track_view(
        raffle: raffle,
        user: user,
        ip_address: '192.168.1.1',
        user_agent: 'Mozilla/5.0'
      )

      assert_equal raffle, view.raffle
      assert_equal user, view.user
      assert_equal '192.168.1.1', view.ip_address
      assert_equal 'Mozilla/5.0', view.user_agent
      assert_in_delta Time.current, view.viewed_at, 1.second
    end
  end

  test 'track_view returns existing view when duplicate' do
    raffle = raffles(:iphone_giveaway)
    user = users(:leo)
    ip_address = '192.168.1.1'

    # Create initial view
    initial_view = RaffleView.track_view(
      raffle: raffle,
      user: user,
      ip_address: ip_address
    )

    # Try to track same view again
    assert_no_difference 'RaffleView.count' do
      duplicate_view = RaffleView.track_view(
        raffle: raffle,
        user: user,
        ip_address: ip_address
      )

      assert_equal initial_view, duplicate_view
    end
  end

  test 'track_view allows different users to view same raffle' do
    raffle = raffles(:dyson_comb)  # Use a different raffle to avoid fixture conflicts

    leo_view = RaffleView.track_view(
      raffle: raffle,
      user: users(:leo),
      ip_address: '192.168.1.1'
    )

    bob_view = RaffleView.track_view(
      raffle: raffle,
      user: users(:bob),
      ip_address: '192.168.1.2'
    )

    assert_not_equal leo_view, bob_view
    assert_equal 2, RaffleView.where(raffle: raffle).count
  end

  test 'track_view allows anonymous users' do
    raffle = raffles(:dyson_comb)  # Use a different raffle to avoid fixture conflicts

    view = RaffleView.track_view(
      raffle: raffle,
      user: nil,
      ip_address: '192.168.1.1',
      user_agent: 'Mozilla/5.0'
    )

    assert_equal raffle, view.raffle
    assert_nil view.user
    assert_equal '192.168.1.1', view.ip_address
    assert_equal 'Mozilla/5.0', view.user_agent
  end

  test 'unique_viewers_today returns count of unique viewers for raffle' do
    raffle = raffles(:dyson_comb)  # Use a different raffle to avoid fixture conflicts

    # Create views from different users/IPs
    RaffleView.track_view(raffle: raffle, user: users(:leo), ip_address: '192.168.1.1')
    RaffleView.track_view(raffle: raffle, user: users(:bob), ip_address: '192.168.1.2')
    RaffleView.track_view(raffle: raffle, user: nil, ip_address: '192.168.1.3')

    # Create duplicate view (should not count)
    RaffleView.track_view(raffle: raffle, user: users(:leo), ip_address: '192.168.1.1')

    count = RaffleView.unique_viewers_today(raffle)

    assert_equal 3, count
  end

  test 'unique_viewers_today returns 0 when no views' do
    raffle = raffles(:apple_watch_series_10)  # Use a different raffle to avoid fixture conflicts

    count = RaffleView.unique_viewers_today(raffle)

    assert_equal 0, count
  end

  test 'unique_viewers_today only counts today views' do
    raffle = raffles(:apple_watch_series_10)  # Use a different raffle to avoid fixture conflicts

    # Create view from yesterday
    RaffleView.create!(
      raffle: raffle,
      user: users(:leo),
      viewed_at: 1.day.ago,
      ip_address: '192.168.1.1'
    )

    # Create view from today
    RaffleView.track_view(raffle: raffle, user: users(:bob), ip_address: '192.168.1.2')

    count = RaffleView.unique_viewers_today(raffle)

    assert_equal 1, count
  end
end
