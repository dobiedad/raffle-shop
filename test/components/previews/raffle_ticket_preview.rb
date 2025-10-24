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

  def reward_ticket
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')
    ticket = create_reward_ticket(raffle)

    render UI::RaffleTicket.new(ticket: ticket)
  end

  private

  def create_sample_ticket(raffle, purchased_at = Time.current)
    user = User.first || User.create!(
      first_name: 'Sample',
      last_name: 'User',
      email: 'sample@example.com',
      password: 'password123'
    )

    raffle.raffle_tickets.create!(
      user: user,
      price: raffle.ticket_price,
      purchased_at: purchased_at
    )
  end

  def create_reward_ticket(raffle)
    referrer = User.find_by(email: 'referrer@example.com') || User.create!(
      first_name: 'Referrer',
      last_name: 'User',
      email: 'referrer@example.com',
      password: 'password123'
    )

    referred_user = User.find_by(email: 'referred_user@example.com') || User.create!(
      first_name: 'referred_user',
      last_name: 'User',
      email: 'referred_user@example.com',
      password: 'password123',
      referred_by: referrer
    )

    raffle.raffle_tickets.create!(
      user: referrer,
      referred_user: referred_user,
      price: raffle.ticket_price,
      purchased_at: Time.current
    )
  end
end
