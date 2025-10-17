# frozen_string_literal: true

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  test 'belongs to wallet' do
    transaction = transactions(:leo_initial_deposit)

    assert_equal wallets(:leo_wallet), transaction.wallet
  end

  test 'validates amount is positive' do
    transaction = Transaction.new(
      wallet: wallets(:leo_wallet),
      amount: -10,
      direction: :debit,
      transaction_type: :withdrawal,
      description: 'Test'
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:amount], 'must be greater than 0'
  end

  test 'validates presence of direction' do
    transaction = Transaction.new(
      wallet: wallets(:leo_wallet),
      amount: 10,
      transaction_type: :deposit,
      description: 'Test'
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:direction], "can't be blank"
  end

  test 'validates presence of transaction_type' do
    transaction = Transaction.new(
      wallet: wallets(:leo_wallet),
      amount: 10,
      direction: :credit,
      description: 'Test'
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:transaction_type], "can't be blank"
  end

  test 'validates presence of description' do
    transaction = Transaction.new(
      wallet: wallets(:leo_wallet),
      amount: 10,
      direction: :credit,
      transaction_type: :deposit
    )

    assert_not transaction.valid?
    assert_includes transaction.errors[:description], "can't be blank"
  end

  test 'direction enum works correctly' do
    transaction = Transaction.create!(
      wallet: wallets(:leo_wallet),
      amount: 10,
      direction: :credit,
      transaction_type: :deposit,
      description: 'Test credit'
    )

    assert_predicate transaction, :credit?
    assert_not transaction.debit?

    transaction.update!(direction: :debit)

    assert_predicate transaction, :debit?
    assert_not transaction.credit?
  end

  test 'transaction_type enum works correctly' do
    transaction = Transaction.create!(
      wallet: wallets(:leo_wallet),
      amount: 10,
      direction: :credit,
      transaction_type: :deposit,
      description: 'Test'
    )

    assert_predicate transaction, :deposit?

    transaction.update!(transaction_type: :ticket_purchase)

    assert_predicate transaction, :ticket_purchase?

    transaction.update!(transaction_type: :raffle_prize)

    assert_predicate transaction, :raffle_prize?
  end

  test '#signed_amount returns positive for credit' do
    transaction = Transaction.new(
      wallet: wallets(:leo_wallet),
      amount: 50,
      direction: :credit,
      transaction_type: :deposit,
      description: 'Test'
    )

    assert_equal 50, transaction.signed_amount
  end

  test '#signed_amount returns negative for debit' do
    transaction = Transaction.new(
      wallet: wallets(:leo_wallet),
      amount: 30,
      direction: :debit,
      transaction_type: :withdrawal,
      description: 'Test'
    )

    assert_equal(-30, transaction.signed_amount)
  end

  test '#transaction_type_display_type returns success for deposit' do
    transaction = Transaction.new(transaction_type: :deposit)

    assert_equal :success, transaction.transaction_type_display_type
  end

  test '#transaction_type_display_type returns warning for withdrawal' do
    transaction = Transaction.new(transaction_type: :withdrawal)

    assert_equal :warning, transaction.transaction_type_display_type
  end

  test '#transaction_type_display_type returns info for ticket_purchase' do
    transaction = Transaction.new(transaction_type: :ticket_purchase)

    assert_equal :info, transaction.transaction_type_display_type
  end

  test '#transaction_type_display_type returns success for raffle_prize' do
    transaction = Transaction.new(transaction_type: :raffle_prize)

    assert_equal :success, transaction.transaction_type_display_type
  end

  test '#transaction_type_display_type returns primary for seller_payout' do
    transaction = Transaction.new(transaction_type: :seller_payout)

    assert_equal :primary, transaction.transaction_type_display_type
  end

  test '#transaction_type_display_type returns warning for refund' do
    transaction = Transaction.new(transaction_type: :refund)

    assert_equal :warning, transaction.transaction_type_display_type
  end

  test '.transaction_icon returns deposit icon' do
    assert_equal '💳', Transaction.transaction_icon(:deposit)
  end

  test '.transaction_icon returns withdrawal icon' do
    assert_equal '🏧', Transaction.transaction_icon(:withdrawal)
  end

  test '.transaction_icon returns ticket purchase icon' do
    assert_equal '🎟️', Transaction.transaction_icon(:ticket_purchase)
  end

  test '.transaction_icon returns raffle prize icon' do
    assert_equal '🎉', Transaction.transaction_icon(:raffle_prize)
  end

  test '.transaction_icon returns seller payout icon' do
    assert_equal '💰', Transaction.transaction_icon(:seller_payout)
  end

  test '.transaction_icon returns refund icon' do
    assert_equal '↩️', Transaction.transaction_icon(:refund)
  end

  test '.transaction_icon returns default icon for unknown type' do
    assert_equal '💵', Transaction.transaction_icon(:unknown)
  end

  test '#icon returns correct icon for transaction' do
    transaction = Transaction.new(transaction_type: :deposit)

    assert_equal '💳', transaction.icon
  end
end
