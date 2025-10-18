# frozen_string_literal: true

module UI
  class RaffleTicket < ApplicationViewComponent
    attribute :ticket, required: true
    attribute :show_raffle_name, default: true

    delegate :ticket_number, :purchased_at, :price, :raffle, to: :ticket

    def ticket_code
      ticket.id.to_s.last(8).upcase
    end

    def purchased_time_ago
      "#{time_ago_in_words(purchased_at)} ago"
    end
  end
end
