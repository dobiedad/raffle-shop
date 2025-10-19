# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[followers following]
  before_action :set_user, only: %i[show followers following raffles]
  before_action :require_user_for_profile, only: :show

  def show
    stats = UserProfileStats.new(user: @user, viewing_user: current_user)

    @tickets_entered_count = stats.tickets_entered_count
    @total_spent = stats.total_spent
    @raffles_won_count = stats.raffles_won_count
    @wallet_balance = stats.wallet_balance
    @recent_activities = stats.recent_activities
    @own_profile = stats.own_profile?
  end

  def followers
    @pagy, @followers = pagy(@user.followers.order(created_at: :desc), limit: 20)
  end

  def following
    @pagy, @followings = pagy(@user.followings.order(created_at: :desc), limit: 20)
  end

  def raffles
    @status_filter = params[:status] || 'active'
    @tab_filter = params[:tab] || 'created'

    filter = UserRafflesFilter.new(user: @user, tab: @tab_filter, status: @status_filter)
    @pagy, @raffles = pagy(filter.scope, limit: 6)
  end

  private

  def set_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def require_user_for_profile
    authenticate_user! if @user.nil?
  end
end
