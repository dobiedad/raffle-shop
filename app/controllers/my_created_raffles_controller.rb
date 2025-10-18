# frozen_string_literal: true

class MyCreatedRafflesController < ApplicationController
  before_action :authenticate_user!

  def index
    @status_filter = params[:status] || 'active'

    raffles_scope = if @status_filter == 'completed'
                      current_user.raffles.where(status: [:completed, :cancelled])
                    else
                      current_user.raffles.where(status: :active)
                    end

    @pagy, @raffles = pagy(raffles_scope.order(created_at: :desc), limit: 6)
  end
end
