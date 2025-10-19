# frozen_string_literal: true

module UI
  class RaffleProgress < ApplicationViewComponent
    attribute :raffle, required: true
    attribute :compact, default: false

    def tickets_sold_display
      raffle.tickets_sold_count || 0
    end

    def progress_percentage
      sold = raffle.tickets_sold_count || 0
      max = raffle.max_tickets
      return 0 if max.zero?

      ((sold.to_f / max) * 100).round
    end

    def amount_raised
      raffle.amount_raised
    end

    def price_goal
      raffle.price
    end

    def max_tickets
      raffle.max_tickets
    end
  end
end

