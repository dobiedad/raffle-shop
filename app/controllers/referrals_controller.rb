# frozen_string_literal: true

class ReferralsController < ApplicationController
  before_action :authenticate_user!

  def index
    @referred_users = current_user.referred_users.order(created_at: :desc)
    @referral_stats = {
      total_referrals: @referred_users.count,
      active_referrals: @referred_users.joins(:raffle_tickets).distinct.count,
      total_tickets_earned: calculate_tickets_earned
    }
  end

  private

  def calculate_tickets_earned
    # Calculate tickets earned based on referral rewards
    # For each referred user, count their first 10 raffle entries
    total_tickets = 0
    @referred_users.each do |user|
      user_tickets = user.raffle_tickets.order(:created_at).limit(10).count
      total_tickets += user_tickets
    end
    total_tickets
  end
end
