# frozen_string_literal: true

class RafflesController < ApplicationController
  # TODO: make this the default and skip where we dont need it
  before_action :authenticate_user!, except: %i[index show]

  def index
    @raffles = Raffle.order(created_at: :desc)
  end

  def show
    @raffle = Raffle.find(params[:id])
  end

  def new
    @raffle = current_user.raffles.build
  end

  def create
    @raffle = current_user.raffles.create(raffle_params)

    respond_with @raffle
  end

  private

  def raffle_params
    params.expect(raffle: %i[name description price ticket_price image])
  end
end
