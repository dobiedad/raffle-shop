# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    @tickets_entered_count = 24
    @total_spent = 92.50
    @raffles_won_count = 2
    @wallet_balance = 42.00

    @recent_activities = [
      { description: '🎟️ Entered "iPhone 15 Pro Giveaway" — 5 tickets', time_ago: '2 hours ago' },
      { description: '🏆 Won "Wireless Headphones Raffle"', time_ago: '3 days ago' },
      { description: '🎟️ Entered "Gaming PC Bundle" — 3 tickets', time_ago: '5 days ago' },
      { description: '💳 Added $50.00 wallet credit', time_ago: '1 week ago' },
      { description: '🎟️ Entered "Apple Watch Ultra" — 2 tickets', time_ago: '1 week ago' },
      { description: '🎟️ Created "Vintage Camera Raffle"', time_ago: '2 weeks ago' },
      { description: '🏆 Won "Premium Coffee Maker"', time_ago: '3 weeks ago' },
      { description: '🎟️ Entered "MacBook Air Raffle" — 10 tickets', time_ago: '1 month ago' }
    ]
  end
end
