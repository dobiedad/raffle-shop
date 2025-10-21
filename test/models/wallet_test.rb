# frozen_string_literal: true

require 'test_helper'

class WalletTest < ActiveSupport::TestCase
  test 'belongs to user' do
    wallet = wallets(:leo_wallet)

    assert_equal leo, wallet.user
  end

  test 'has many transactions' do
    wallet = wallets(:leo_wallet)

    assert_respond_to wallet, :transactions
  end

  test 'validates balance cannot be negative' do
    wallet = Wallet.new(user: leo, balance: -10)

    assert_not wallet.valid?
    assert_includes wallet.errors[:balance], 'must be greater than or equal to 0'
  end

  test 'starts with zero balance' do
    user = User.create!(first_name: 'Test', last_name: 'User', email: 'test@example.com', password: 'password123')

    assert_equal 0, user.wallet.balance
  end

  test '#add increases balance and creates credit transaction' do
    wallet = wallets(:leo_wallet)
    initial_balance = wallet.balance

    wallet.add(50.0, 'Test deposit', transaction_type: :deposit)

    wallet.reload

    assert_equal initial_balance + 50.0, wallet.balance

    transaction = wallet.transactions.last

    assert_in_delta(50.0, transaction.amount)
    assert_predicate transaction, :credit?
    assert_equal 'deposit', transaction.transaction_type
    assert_equal 'Test deposit', transaction.description
  end

  test '#add raises error for negative amount' do
    wallet = wallets(:leo_wallet)

    assert_raises(ArgumentError) do
      wallet.add(-10.0, 'Invalid', transaction_type: :deposit)
    end
  end

  test '#deduct decreases balance and creates debit transaction' do
    wallet = wallets(:leo_wallet)
    wallet.update!(balance: 100.0)
    initial_balance = wallet.balance

    wallet.deduct(30.0, 'Test withdrawal', transaction_type: :withdrawal)

    wallet.reload

    assert_equal initial_balance - 30.0, wallet.balance

    transaction = wallet.transactions.last

    assert_in_delta(30.0, transaction.amount)
    assert_predicate transaction, :debit?
    assert_equal 'withdrawal', transaction.transaction_type
    assert_equal 'Test withdrawal', transaction.description
  end

  test '#deduct raises error for insufficient funds' do
    wallet = wallets(:leo_wallet)
    wallet.update!(balance: 10.0)

    assert_raises(InsufficientFundsError) do
      wallet.deduct(20.0, 'Too much', transaction_type: :withdrawal)
    end
  end

  test '#deduct raises error for negative amount' do
    wallet = wallets(:leo_wallet)

    assert_raises(ArgumentError) do
      wallet.deduct(-10.0, 'Invalid', transaction_type: :withdrawal)
    end
  end

  test '#sufficient_funds? returns true when balance is enough' do
    wallet = wallets(:leo_wallet)
    wallet.update!(balance: 100.0)

    assert wallet.sufficient_funds?(50.0)
    assert wallet.sufficient_funds?(100.0)
  end

  test '#sufficient_funds? returns false when balance is not enough' do
    wallet = wallets(:leo_wallet)
    wallet.update!(balance: 10.0)

    assert_not wallet.sufficient_funds?(20.0)
  end

  test 'transactions are atomic' do
    wallet = wallets(:leo_wallet)
    wallet.update!(balance: 100.0)

    wallet.transactions.stub(:create!, ->(*) { raise ActiveRecord::RecordInvalid }) do
      assert_raises(ActiveRecord::RecordInvalid) do
        wallet.add(50.0, 'Test', transaction_type: :deposit)
      end
    end

    wallet.reload

    assert_in_delta(100.0, wallet.balance)
  end
end
