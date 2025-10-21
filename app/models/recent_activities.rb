# frozen_string_literal: true

class RecentActivities
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActionView::Helpers::DateHelper

  attribute :user
  attribute :activities, default: -> { [] }

  def self.build(user)
    instance = new(user: user)
    instance.build_activities
    instance
  end

  def build_activities
    self.activities = []

    add_transaction_activities
    add_raffles_won_activities
    add_raffles_created_activities

    sort_and_format_activities
    activities
  end

  private

  def add_transaction_activities
    return unless user.wallet

    user.wallet.transactions.order(created_at: :desc).limit(15).each do |transaction|
      activities << {
        description: "#{transaction.icon} #{transaction.description}",
        time_ago: time_ago_in_words(transaction.created_at),
        timestamp: transaction.created_at
      }
    end
  end

  def add_raffles_won_activities
    user.raffles_won.order(drawn_at: :desc).limit(3).each do |raffle|
      activities << {
        description: "🏆 Won \"#{raffle.name}\"",
        time_ago: time_ago_in_words(raffle.drawn_at),
        timestamp: raffle.drawn_at
      }
    end
  end

  def add_raffles_created_activities
    user.raffles.order(created_at: :desc).limit(3).each do |raffle|
      activities << {
        description: "🎯 Created raffle \"#{raffle.name}\"",
        time_ago: time_ago_in_words(raffle.created_at),
        timestamp: raffle.created_at
      }
    end
  end

  def sort_and_format_activities
    self.activities = activities.sort_by { |a| a[:timestamp] }.reverse.first(9).each do |activity|
      activity[:time_ago] = "#{activity[:time_ago]} ago"
    end
  end
end
