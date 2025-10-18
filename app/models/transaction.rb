# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :wallet
  belongs_to :related, polymorphic: true, optional: true

  enum :direction, { debit: 'debit', credit: 'credit' }
  enum :transaction_type, {
    deposit: 'deposit',
    withdrawal: 'withdrawal',
    ticket_purchase: 'ticket_purchase',
    raffle_prize: 'raffle_prize',
    seller_payout: 'seller_payout',
    refund: 'refund'
  }

  validates :amount, numericality: { greater_than: 0 }
  validates :direction, :transaction_type, :description, presence: true

  def signed_amount
    debit? ? -amount : amount
  end

  def transaction_type_display_type
    {
      deposit: :success,
      withdrawal: :warning,
      ticket_purchase: :info,
      raffle_prize: :success,
      seller_payout: :primary,
      refund: :warning
    }.fetch(transaction_type.to_sym, :light)
  end

  def icon
    self.class.transaction_icon(transaction_type.to_sym)
  end

  def self.transaction_icon(transaction_type)
    case transaction_type
    when :deposit then '💳'
    when :withdrawal then '🏧'
    when :ticket_purchase then '🎟️'
    when :raffle_prize then '🎉'
    when :seller_payout then '💰'
    when :refund then '↩️'
    else '💵'
    end
  end
end
