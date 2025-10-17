# frozen_string_literal: true

class RaffleTicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @raffle_tickets = current_user.raffle_tickets.includes(:raffle).order(created_at: :desc)
  end

  def create
    @raffle = Raffle.find(params[:raffle_id])

    if @raffle.buy_ticket(buyer: current_user, quantity: quantity)
      redirect_to @raffle, notice: "You have purchased #{quantity} ticket."
    else
      redirect_to @raffle, alert: @raffle.errors.full_messages.join(',')
    end
  end

  private

  def quantity
    params[:quantity].to_i
  end
end
