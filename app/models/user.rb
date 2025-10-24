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
  has_many :referral_reward_tickets,
           -> { where.not(referred_user_id: nil) },
           class_name: 'RaffleTicket',
           foreign_key: :user_id,
           inverse_of: :user,
           dependent: :nullify
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followed_id', dependent: :destroy,
                             inverse_of: :followed
  has_many :followings, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower
  has_many :user_activities, dependent: :destroy

  belongs_to :referred_by, class_name: 'User', optional: true
  has_many :referred_users, class_name: 'User', foreign_key: 'referred_by_id', dependent: :nullify,
                            inverse_of: :referred_by

  after_create :create_wallet, :generate_referral_code

  delegate :balance, to: :wallet

  validates :first_name, :last_name, presence: true

  validates :profile_image,
            content_type: { in: ['image/png', 'image/jpeg', 'image/gif', 'image/webp'],
                            message: 'must be a JPEG, PNG, GIF, or WebP' },
            size: { less_than: 5.megabytes,
                    message: 'must be less than 5MB' }

  def full_name
    "#{first_name} #{last_name}"
  end

  def following?(other)
    followings.include?(other)
  end

  def follow!(other)
    return if self == other
    return if following?(other)

    active_follows.create!(followed: other)
  end

  def unfollow!(other)
    follow = active_follows.find_by!(followed: other)

    follow.destroy
  end

  def can_receive_referral_reward?(raffle)
    return false if referral_reward_tickets.count >= 10

    !referral_reward_tickets.exists?(raffle: raffle)
  end

  private

  def generate_referral_code
    self.referral_code = generate_unique_referral_code
    save!
  end

  def generate_unique_referral_code
    loop do
      pid = Process.pid.to_s[-4..]
      random = SecureRandom.hex(3).upcase
      code = "#{pid}#{random}"
      break code unless User.exists?(referral_code: code)
    end
  end
end
