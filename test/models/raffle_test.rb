# frozen_string_literal: true

require 'test_helper'

class RaffleTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", name: nil
    assert_invalid "can't be blank", description: nil
    assert_invalid "can't be blank", 'is not a number', price: nil
    assert_invalid "can't be blank", 'is not a number', ticket_price: nil
    assert_invalid 'must be greater than 0', price: 0
    assert_invalid 'must be greater than 2', ticket_price: 0
    assert_invalid 'must be less than 100', ticket_price: 101
  end

  test 'accepts valid image formats' do
    raffle = raffles(:iphone_giveaway)

    assert_predicate raffle, :valid?
    assert_predicate raffle.images, :attached?
  end

  test 'rejects more than 10 images' do
    raffle = raffles(:iphone_giveaway)

    8.times do
      raffle.images.attach(
        io: Rails.root.join('test/fixtures/files/image_one.jpg').open,
        filename: 'test.jpg',
        content_type: 'image/jpeg'
      )
    end

    assert_not raffle.valid?
    assert_includes raffle.errors[:images], 'cannot be more than 10 images'
  end

  test 'rejects non-image files' do
    raffle = Raffle.new(
      name: 'Test',
      description: 'Test',
      price: 100,
      ticket_price: 5,
      user: users(:leo)
    )

    raffle.images.attach(
      io: StringIO.new('fake pdf content'),
      filename: 'document.pdf',
      content_type: 'application/pdf'
    )

    assert_not raffle.valid?
    assert_includes raffle.errors[:images], 'must be a JPEG, PNG, GIF, or WebP'
  end

  test 'rejects images larger than 10MB' do
    raffle = Raffle.new(
      name: 'Test',
      description: 'Test',
      price: 100,
      ticket_price: 5,
      user: users(:leo)
    )

    large_content = 'x' * (11 * 1024 * 1024)
    raffle.images.attach(
      io: StringIO.new(large_content),
      filename: 'huge.jpg',
      content_type: 'image/jpeg'
    )

    assert_not raffle.valid?
    assert_includes raffle.errors[:images], 'must be less than 10MB'
  end
end
