# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user

    @tickets_entered_count = @user.raffle_tickets.count
    @total_spent = @user.raffle_tickets.sum(:price)
    @raffles_won_count = @user.raffles_won.count
    @wallet_balance = @user.wallet&.balance || 0

    @recent_activities = RecentActivities.build(@user).activities
  end
end
