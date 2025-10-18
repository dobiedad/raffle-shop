# frozen_string_literal: true

class RaffleTicket < ApplicationRecord
  include Hashid::Rails

  belongs_to :raffle
  belongs_to :user
  has_one :purchase_transaction, class_name: 'Transaction', as: :related, dependent: :nullify

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :purchased_at, presence: true

  def ticket_number
    hashid.upcase
  end
end
