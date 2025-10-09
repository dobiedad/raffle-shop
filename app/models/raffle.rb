# frozen_string_literal: true

class Raffle < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
end
