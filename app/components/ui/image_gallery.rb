# frozen_string_literal: true

module UI
  class ImageGallery < ApplicationViewComponent
    attribute :images, required: true
    attribute :alt_prefix, default: 'Image'

    def multiple_images?
      images.length > 1
    end

    def first_image
      images.first
    end

    def total_images
      images.length
    end
  end
end
