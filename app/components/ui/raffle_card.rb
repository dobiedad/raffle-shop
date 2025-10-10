# frozen_string_literal: true

module UI
  class RaffleCard < ApplicationViewComponent
    attribute :raffle, required: true

    def has_image?
      raffle.images.attached?
    end

    def first_image
      raffle.images.first
    end

    def default_image_url
      "https://community.softr.io/uploads/db9110/original/2X/7/74e6e7e382d0ff5d7773ca9a87e6f6f8817a68a6.jpeg"
    end

    def truncated_description
      truncate(raffle.description.to_plain_text, length: 100)
    end
  end
end
