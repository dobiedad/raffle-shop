# frozen_string_literal: true

# This preview allows you to see the component in different states during development
class ImageGalleryPreview < ComponentPreview
  def default
    images = fixture_images(['ps5_one.jpg', 'ps5_two.jpg', 'ps5_three.jpg'])

    render UI::ImageGallery.new(images: images, alt_prefix: 'Multi-image Raffle')
  end

  def single_image
    images = fixture_images(['image_one.jpg'])

    render UI::ImageGallery.new(images: images, alt_prefix: 'Single Image Raffle')
  end

  private

  def fixture_images(filenames)
    filenames.map do |filename|
      file_path = Rails.root.join('test/fixtures/files', filename)
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(file_path),
        filename: filename,
        content_type: 'image/jpeg'
      )
    end
  end
end
