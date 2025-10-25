# frozen_string_literal: true

class AchievementsRegistry # rubocop:disable Metrics/ClassLength
  ACHIEVEMENTS = {
    first_win: {
      description: 'Win your first raffle',
      icon: '🏆',
      color: 'is-success'
    },
    trusted_user: {
      description: 'Create 5 raffles',
      icon: '⭐',
      color: 'is-info'
    },
    early_adopter: {
      description: 'Be active for 30 days',
      icon: '🎖️',
      color: 'is-warning'
    },
    big_spender: {
      description: 'Spend $100 total',
      icon: '💰',
      color: 'is-primary'
    },
    hot_streak: {
      description: 'Win 3 raffles in a row',
      icon: '🔥',
      color: 'is-danger'
    },
    ticket_collector: {
      description: 'Buy 50 tickets',
      icon: '🎟️',
      color: 'is-link'
    },
    lucky_winner: {
      description: 'Win 3 raffles',
      icon: '🎉',
      color: 'is-success'
    },
    raffle_master: {
      description: 'Create 10 raffles',
      icon: '👑',
      color: 'is-info'
    },
    high_roller: {
      description: 'Spend $500 total',
      icon: '💎',
      color: 'is-primary'
    },
    popular: {
      description: 'Get 25 followers',
      icon: '👥',
      color: 'is-warning'
    },
    veteran: {
      description: 'Be active for 90 days',
      icon: '🎖️',
      color: 'is-warning'
    },
    ticket_master: {
      description: 'Buy 100 tickets',
      icon: '🎫',
      color: 'is-link'
    }
  }.freeze

  def self.all
    ACHIEVEMENTS.map { |key, attrs| Achievement.new(name: key, **attrs) }
  end

  def self.active
    all.select(&:active)
  end

  def self.find_by_name(name)
    attrs = ACHIEVEMENTS[name]
    attrs ? Achievement.new(name: name, **attrs) : nil
  end
end
