# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def currency_symbol
    Rails.application.config.x.currency_symbol
  end

  def format_currency(amount)
    "#{currency_symbol}#{number_with_precision(amount, precision: 2)}"
  end
end
