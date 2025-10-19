# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    current_user.follow!(@user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user), notice: "You are now following #{@user.email}" }
    end
  end

  def destroy
    current_user.unfollow!(@user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user), notice: "You unfollowed #{@user.email}" }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
