# frozen_string_literal: true

class Raffle < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_rich_text :description

  validates :name, :description, :price, :ticket_price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :ticket_price, numericality: { greater_than: 2, less_than: 100 }
end
