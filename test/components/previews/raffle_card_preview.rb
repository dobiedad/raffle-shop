# frozen_string_literal: true

require_relative '../../../app/components/ui/raffle_card'

class RaffleCardPreview < ComponentPreview
  def default
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')

    render UI::RaffleCard.new(raffle: raffle)
  end

  def with_ticket_badge
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')

    render UI::RaffleCard.new(raffle: raffle, badge_text: '3 tickets')
  end

  def with_won_badge
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')

    render UI::RaffleCard.new(raffle: raffle, badge_text: '🏆 You Won!')
  end

  def with_winner_badge
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')

    render UI::RaffleCard.new(raffle: raffle, badge_text: 'Winner: john')
  end

  def with_cancelled_badge
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')

    render UI::RaffleCard.new(raffle: raffle, badge_text: '❌ Cancelled')
  end

  def without_image
    raffle = Raffle.find_by!(name: 'PS5 Console + Extra Controller')

    render UI::RaffleCard.new(raffle: raffle)
  end

  def high_ticket_price
    raffle = Raffle.find_by!(name: 'ROLEX Yacht-Master 40mm Blue')

    render UI::RaffleCard.new(raffle: raffle)
  end

  def different_category
    raffle = Raffle.find_by!(name: 'Dyson Airwrap Complete')

    render UI::RaffleCard.new(raffle: raffle)
  end
end
