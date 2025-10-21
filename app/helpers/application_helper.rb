# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def currency_symbol
    Rails.application.config.x.currency_symbol
  end

  def format_currency(amount)
    number_to_currency(amount, unit: currency_symbol, precision: 2)
  end
end
