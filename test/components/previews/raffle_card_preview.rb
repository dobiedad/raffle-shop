# frozen_string_literal: true

require_relative '../../../app/components/ui/raffle_card'

# This preview allows you to see the component in different states during development
class RaffleCardPreview < ComponentPreview
  def default
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')

    render UI::RaffleCard.new(raffle: raffle)
  end

  def with_default_image
    raffle = Raffle.find_by!(name: 'PS5 Console + Extra Controller')

    render UI::RaffleCard.new(raffle: raffle)
  end

  def long_description
    # Create a raffle with a long description for testing truncation
    raffle = Raffle.find_by!(name: 'iPhone 15 Pro Max')

    render UI::RaffleCard.new(raffle: raffle)
  end
end
