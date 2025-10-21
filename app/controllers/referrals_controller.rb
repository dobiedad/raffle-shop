# frozen_string_literal: true

class ReferralsController < ApplicationController
  before_action :authenticate_user!

  def index
    @referred_users = current_user.referred_users.order(created_at: :desc)
    @referral_stats = {
      total_referrals: @referred_users.count,
      active_referrals: @referred_users.joins(:raffle_tickets).distinct.count,
      total_tickets_earned: 0
    }
  end
end
