# frozen_string_literal: true

module UI
  class RaffleCard < ApplicationViewComponent
    attribute :raffle, required: true

    def image?
      raffle.images.attached?
    end

    def first_image
      raffle.images.first
    end

    def default_image_url
      'https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg'
    end

    def truncated_description
      truncate(raffle.general_description.to_plain_text, length: 80)
    end

    delegate :tickets_sold_count, to: :raffle
    delegate :days_remaining, to: :raffle

    def days_remaining_text
      days = days_remaining
      return '' if days.nil?
      return 'Ended' if days <= 0
      return 'Less than 1 day' if days <= 1

      "#{days}d left"
    end
  end
end
