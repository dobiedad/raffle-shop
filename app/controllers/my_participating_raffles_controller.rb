# frozen_string_literal: true

class MyParticipatingRafflesController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @raffles = pagy(Raffle.where.not(user_id: current_user.id).order(Arel.sql('RANDOM()')), limit: 6)
  end
end
