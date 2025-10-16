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

  def self.ransackable_attributes(_auth_object = nil)
    %w[name category price ticket_price created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user]
  end

  # Helper methods for stats
  def tickets_sold_count
    0 # TODO: Implement when Ticket model exists
  end

  def amount_raised
    0.0 # TODO: Implement when Ticket model exists
  end

  def days_remaining
    return nil if end_date.nil?

    [(end_date.to_date - Date.current).to_i, 0].max
  end
end
