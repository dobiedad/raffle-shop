# frozen_string_literal: true

class MyCreatedRafflesController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @raffles = pagy(current_user.raffles.order(created_at: :desc), limit: 6)
  end
end
