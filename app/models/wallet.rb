# frozen_string_literal: true

class Wallet < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def add(amount, description, transaction_type:)
    raise ArgumentError, 'Amount must be positive' if amount <= 0

    ActiveRecord::Base.transaction do
      update!(balance: balance + amount)
      transactions.create!(
        amount: amount,
        direction: :credit,
        transaction_type: transaction_type,
        description: description
      )
    end
  end

  def deduct(amount, description, transaction_type:)
    raise ArgumentError, 'Amount must be positive' if amount <= 0
    raise InsufficientFundsError, 'Insufficient funds' unless sufficient_funds?(amount)

    ActiveRecord::Base.transaction do
      update!(balance: balance - amount)
      transactions.create!(
        amount: amount,
        direction: :debit,
        transaction_type: transaction_type,
        description: description
      )
    end
  end

  def sufficient_funds?(amount)
    balance >= amount
  end
end

class InsufficientFundsError < StandardError; end
