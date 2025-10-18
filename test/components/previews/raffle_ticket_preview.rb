# frozen_string_literal: true

require_relative '../../../app/components/ui/raffle_ticket'

class RaffleTicketPreview < ComponentPreview
  def default
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')
    ticket = raffle.raffle_tickets.first || create_sample_ticket(raffle)

    render UI::RaffleTicket.new(ticket: ticket)
  end

  def without_raffle_name
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')
    ticket = raffle.raffle_tickets.first || create_sample_ticket(raffle)

    render UI::RaffleTicket.new(ticket: ticket, show_raffle_name: false)
  end

  def recently_purchased
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')
    ticket = raffle.raffle_tickets.first || create_sample_ticket(raffle, 1.hour.ago)

    render UI::RaffleTicket.new(ticket: ticket)
  end

  def purchased_days_ago
    raffle = Raffle.find_by!(name: 'PS5 Console + Extra Controller')
    ticket = raffle.raffle_tickets.first || create_sample_ticket(raffle, 3.days.ago)

    render UI::RaffleTicket.new(ticket: ticket)
  end

  private

  def create_sample_ticket(raffle, purchased_at = Time.current)
    user = User.first || User.create!(
      email: 'sample@example.com',
      password: 'password123'
    )

    raffle.raffle_tickets.create!(
      user: user,
      price: raffle.ticket_price,
      purchased_at: purchased_at
    )
  end
end
