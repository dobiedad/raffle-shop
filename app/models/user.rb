# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :profile_image

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :wallet, dependent: :destroy
  has_many :raffles, dependent: :destroy
  has_many :raffle_tickets, dependent: :destroy
  has_many :raffles_entered, through: :raffle_tickets, source: :raffle
  has_many :raffles_won, class_name: 'Raffle', foreign_key: 'winner_id', dependent: :nullify, inverse_of: :winner

  after_create :create_wallet

  delegate :balance, to: :wallet

  validates :profile_image,
            content_type: { in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
                            message: 'must be a JPEG, PNG, GIF, or WebP' },
            size: { less_than: 5.megabytes,
                    message: 'must be less than 5MB' }
end
