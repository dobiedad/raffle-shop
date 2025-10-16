# frozen_string_literal: true

class RafflesController < ApplicationController
  # TODO: make this the default and skip where we dont need it
  before_action :authenticate_user!, except: %i[index show]

  def index
    @q = Raffle.ransack(search_params)
    @pagy, @raffles = pagy(@q.result(distinct: true).order(created_at: :desc), limit: 1)
    @total_raffles_count = Raffle.count
    @active_category = params[:category] || 'All'
  end

  def show
    @raffle = Raffle.find(params[:id])
  end

  def new
    @raffle = current_user.raffles.build
    @preview_raffle = build_preview_raffle
  end

  def create
    @raffle = current_user.raffles.create(raffle_params)
    @preview_raffle = build_preview_raffle unless @raffle.persisted?

    respond_with @raffle
  end

  private

  def build_preview_raffle
    current_user.raffles.build(
      name: 'Sample Raffle',
      ticket_price: 3.50,
      description: 'Add details to see your preview...'
    )
  end

  def raffle_params
    params.expect(
      raffle: [
        :name,
        :description,
        :price,
        :ticket_price,
        :category,
        :condition,
        :end_date,
        { images: [] }
      ]
    )
  end

  def search_params
    (params[:q] || {}).merge(category_cont: params[:category])
  end
end
