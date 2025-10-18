# frozen_string_literal: true

class MyParticipatingRafflesController < ApplicationController
  before_action :authenticate_user!

  def index
    @status_filter = params[:status] || 'active'

    participated_raffle_ids = current_user.raffle_tickets.pluck(:raffle_id).uniq

    raffles_scope = if @status_filter == 'completed'
                      Raffle.where(id: participated_raffle_ids)
                            .where(status: %i[completed cancelled])
                            .order(completed_at: :desc)
                    else
                      current_user.raffles_entered.active.distinct.order(created_at: :desc)
                    end

    @pagy, @raffles = pagy(raffles_scope, limit: 6)
  end
end
