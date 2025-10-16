# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :profile_image
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :raffles, dependent: :destroy
  
  validates :profile_image,
            content_type: { in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
                            message: 'must be a JPEG, PNG, GIF, or WebP' },
            size: { less_than: 5.megabytes,
                    message: 'must be less than 5MB' }
end
