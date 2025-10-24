# frozen_string_literal: true

class ReferralsController < ApplicationController
  before_action :authenticate_user!

  def index
    referral_reward_tickets = current_user.referral_reward_tickets
    @referred_users_count = current_user.referred_users.order(created_at: :desc).count
    @total_tickets_earned = referral_reward_tickets.count
    @total_value = referral_reward_tickets.sum(:price)
  end
end
