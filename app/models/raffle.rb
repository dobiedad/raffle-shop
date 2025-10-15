# frozen_string_literal: true

class Raffle < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_rich_text :description

  enum :status, { active: 'active', completed: 'completed' }, default: :active

  validates :name, :description, :price, :ticket_price, :status, :category, :condition, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :ticket_price, numericality: { greater_than: 2, less_than: 100 }
  validates :end_date, comparison: { greater_than: -> { Time.current } }, allow_nil: true

  validates :images,
            content_type: { in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
                            message: 'must be a JPEG, PNG, GIF, or WebP' },
            size: { less_than: 10.megabytes,
                    message: 'must be less than 10MB' },
            limit: { max: 10,
                     message: 'cannot be more than 10 images' }

  scope :by_category, ->(category) { where(category: category) }
end
