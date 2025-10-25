# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!
    before_action :set_user

    def ban
      @user.ban!
      redirect_to admin_root_path, notice: 'User banned successfully'
    end

    def unban
      @user.unban!
      redirect_to admin_root_path, notice: 'User unbanned successfully'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
