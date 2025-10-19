# frozen_string_literal: true

class MyCreatedRafflesController < ApplicationController
  before_action :authenticate_user!

  def index
    @status_filter = params[:status] || 'active'

    filter = UserRafflesFilter.new(user: current_user, tab: 'created', status: @status_filter)
    @pagy, @raffles = pagy(filter.scope, limit: 6)
  end
end
