# frozen_string_literal: true

module Admin
  class RafflesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!
    before_action :set_raffle

    def cancel
      @raffle.cancel!
      redirect_to admin_root_path, notice: 'Raffle cancelled successfully'
    end

    def toggle_auto_draw
      @raffle.update!(auto_draw: !@raffle.auto_draw)
      redirect_to admin_root_path, notice: 'Auto draw setting updated'
    end

    def hand_over
      @raffle.hand_over!
      redirect_to admin_root_path, notice: 'Raffle marked as handed over'
    end

    private

    def set_raffle
      @raffle = Raffle.find(params[:id])
    end
  end
end
