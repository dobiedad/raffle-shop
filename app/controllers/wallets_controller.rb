# frozen_string_literal: true

class WalletsController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!

  def show
    @wallet = current_user.wallet
    @pagy, @transactions = pagy(@wallet.transactions.order(created_at: :desc), items: 25)
  end
end
