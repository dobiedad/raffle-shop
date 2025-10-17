# frozen_string_literal: true

class MyParticipatingRafflesController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @raffles = pagy(current_user.raffles_entered.active.distinct.order(created_at: :desc), limit: 6)
  end
end
