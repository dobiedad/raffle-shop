# frozen_string_literal: true

require 'test_helper'

class RaffleTest < ActiveSupport::TestCase
  test 'validations' do
    assert_invalid "can't be blank", name: nil
    assert_invalid "can't be blank", general_description: nil
    assert_invalid "can't be blank", condition_description: nil
    assert_invalid "can't be blank", whats_included_description: nil
    assert_invalid "can't be blank", 'is not a number', price: nil
    assert_invalid "can't be blank", 'is not a number', ticket_price: nil
    assert_invalid 'must be greater than 0', price: 0
    assert_invalid 'must be greater than 2', ticket_price: 0
    assert_invalid 'must be less than 100', ticket_price: 101
    assert_invalid "can't be blank", status: nil
    assert_invalid "can't be blank", category: nil
    assert_invalid "can't be blank", condition: nil
  end

  test 'rejects more than 10 images' do
    raffle = raffles(:iphone_giveaway)

    8.times do
      raffle.images.attach(
        io: Rails.root.join('test/fixtures/files/image_one.jpg').open,
        filename: 'test.jpg',
        content_type: 'image/jpeg'
      )
    end

    assert_not raffle.valid?
    assert_includes raffle.errors[:images], 'cannot be more than 10 images'
  end

  test 'rejects non-image files' do
    raffle = Raffle.new(
      name: 'Test',
      general_description: 'Test',
      price: 100,
      ticket_price: 5,
      user: users(:leo)
    )

    raffle.images.attach(
      io: StringIO.new('fake pdf content'),
      filename: 'document.pdf',
      content_type: 'application/pdf'
    )

    assert_not raffle.valid?
    assert_includes raffle.errors[:images], 'must be a JPEG, PNG, GIF, or WebP'
  end

  test 'rejects images larger than 10MB' do
    raffle = Raffle.new(
      name: 'Test',
      general_description: 'Test',
      price: 100,
      ticket_price: 5,
      user: users(:leo)
    )

    large_content = 'x' * (11 * 1024 * 1024)
    raffle.images.attach(
      io: StringIO.new(large_content),
      filename: 'huge.jpg',
      content_type: 'image/jpeg'
    )

    assert_not raffle.valid?
    assert_includes raffle.errors[:images], 'must be less than 10MB'
  end

  test '#tickets_sold_count' do
    raffle = raffles(:rolex_yacht_master)
    tickets_for_raffle = RaffleTicket.where(raffle: raffle)

    assert_not_equal 0, tickets_for_raffle.count

    assert_equal tickets_for_raffle.count, raffle.tickets_sold_count
  end

  test '#days_remaining' do
    raffle = raffles(:iphone_giveaway)

    assert_equal 7, raffle.days_remaining
  end

  test 'self.ransackable_attributes' do
    assert_equal %w[name category price ticket_price created_at], subject.class.ransackable_attributes
  end

  test 'self.ransackable_associations' do
    assert_equal %w[user], subject.class.ransackable_associations
  end

  test 'saves platform_fee_percent on create' do
    raffle_with_existing_platform_fee = Raffle.create!(valid_raffle_attributes)
    current_fee_percentage = Raffle::PLATFORM_FEE_PERCENTAGE
    upcoming_fee_percentage = 99

    assert_not_equal current_fee_percentage, upcoming_fee_percentage
    assert_equal current_fee_percentage, raffle_with_existing_platform_fee.platform_fee_percent

    Raffle.stub_const(:PLATFORM_FEE_PERCENTAGE, upcoming_fee_percentage) do
      raffle_with_new_fee = Raffle.create!(valid_raffle_attributes)

      assert_equal upcoming_fee_percentage, raffle_with_new_fee.platform_fee_percent
      assert_equal current_fee_percentage, raffle_with_existing_platform_fee.reload.platform_fee_percent
    end
  end

  test 'platform_fee_percent cannot be updated once saved' do
    raffle_with_existing_platform_fee = Raffle.create!(valid_raffle_attributes)

    assert_equal 20, raffle_with_existing_platform_fee.platform_fee_percent

    assert_raises ActiveRecord::ReadonlyAttributeError do
      raffle_with_existing_platform_fee.update!(platform_fee_percent: 99)
    end
  end

  test 'ticket_price cannot be updated once saved' do
    raffle_with_existing_platform_fee = Raffle.create!(valid_raffle_attributes)

    assert_equal 15, raffle_with_existing_platform_fee.ticket_price

    assert_raises ActiveRecord::ReadonlyAttributeError do
      raffle_with_existing_platform_fee.update!(ticket_price: 99)
    end
  end

  test '#max_tickets includes platform fee percentage' do
    subject.price = 100
    subject.ticket_price = 2.5
    max_without_percentage = 100 / 2.5

    assert_equal 40, max_without_percentage
    assert_equal 48, subject.max_tickets

    subject.ticket_price = 3.5
    new_max_without_percentage = (100 / 3.5).ceil

    assert_equal 29, new_max_without_percentage
    assert_equal 35, subject.max_tickets
  end

  test '#buy_tickets is false if quantity is not greater than one' do
    raffle = raffles(:iphone_giveaway)

    assert_not raffle.buy_tickets(buyer: leo, quantity: 0)

    assert_equal ['Quantity must be greater than 0'], raffle.errors.full_messages
  end

  test '#buy_tickets is false if user does not have enough funds' do
    raffle = raffles(:iphone_giveaway)

    leo.wallet.update!(balance: raffle.ticket_price - 1)

    assert_not raffle.buy_tickets(buyer: leo, quantity: 1)

    assert_equal ['Insufficient funds'], raffle.errors.full_messages
  end

  test '#buy_tickets is false the raffle has already ended' do
    raffle = raffles(:iphone_giveaway)

    raffle.completed!

    assert_not raffle.buy_tickets(buyer: leo, quantity: 1)

    assert_equal ['Raffle is no longer active'], raffle.errors.full_messages
  end

  test '#buy_tickets is false the raffle is cancelled' do
    raffle = raffles(:iphone_giveaway)

    raffle.cancelled!

    assert_not raffle.buy_tickets(buyer: leo, quantity: 1)

    assert_equal ['Raffle is no longer active'], raffle.errors.full_messages
  end

  test '#buy_tickets is false the maximum amount of tickets is already bought' do
    raffle = raffles(:iphone_giveaway)

    assert raffle.buy_tickets(buyer: bob, quantity: 1)

    Raffle.stub_any_instance :max_tickets, 1 do
      assert_not raffle.buy_tickets(buyer: bob, quantity: 1)
      assert_equal ['Maximum amount of tickets have already been bought'], raffle.errors.full_messages
    end
  end

  test '#buy_tickets is false for users trying to buy a ticket for their own raffle' do
    raffle = raffles(:iphone_giveaway)

    assert_not raffle.buy_tickets(buyer: raffle.user, quantity: 1)
    assert_equal ['You cannot buy a ticket for your own raffle'], raffle.errors.full_messages
  end

  test '#buy_tickets' do
    bob.wallet.update!(balance: 100.0)

    raffle = raffles(:iphone_giveaway)
    tickets = raffle.buy_tickets(buyer: bob, quantity: 10)

    assert_equal 10, tickets.count
    assert_equal 10, raffle.raffle_tickets.count
    assert_equal [bob], raffle.raffle_tickets.map(&:user).uniq
    assert_equal raffle.ticket_price, tickets.map(&:price).uniq.sole

    leo.wallet.reload

    assert_equal 100 - (raffle.ticket_price * 10), bob.wallet.balance

    transaction = bob.wallet.transactions.last

    assert_includes transaction.description, raffle.name
    assert_includes transaction.description, "10 tickets (##{tickets.map(&:ticket_number).join(', ')})"
  end

  test '#amount_raised' do
    raffle = raffles(:iphone_giveaway)

    assert_equal 0, raffle.amount_raised

    assert raffle.buy_tickets(buyer: bob, quantity: 2)

    assert_equal raffle.ticket_price * 2, raffle.reload.amount_raised
  end

  test '#eligible_for_draw?' do
    raffle = raffles(:iphone_giveaway)

    assert_not raffle.eligible_for_draw?

    raffle.update!(end_date: 1.second.ago)

    assert_predicate raffle, :eligible_for_draw?

    raffle.draw_winner!

    assert_not raffle.eligible_for_draw?
  end

  test '#eligible_for_draw? is true if end date is not reached but max tickets are bought' do
    raffle = raffles(:iphone_giveaway)

    raffle.update!(end_date: 1.day.from_now)

    assert_not raffle.eligible_for_draw?

    bob.wallet.update!(balance: 100_000.0)
    raffle.buy_tickets(buyer: bob, quantity: raffle.max_tickets)

    assert_predicate raffle, :eligible_for_draw?
  end

  test '#draw_winner! selects winner and distributes funds' do
    raffle = raffles(:iphone_giveaway)

    bob.wallet.update!(balance: 100_000.0)
    raffle.buy_tickets(buyer: bob, quantity: raffle.max_tickets)

    seller = raffle.user
    initial_seller_balance = seller.wallet.balance

    winner = raffle.draw_winner!

    assert_equal bob, winner
    assert_predicate raffle, :completed?
    assert_not_nil raffle.drawn_at
    assert_not_nil raffle.completed_at

    seller.wallet.reload

    expected_payout = raffle.price

    assert_equal 'Payout for raffle: iPhone 15 Pro Max', seller.wallet.transactions.last.description

    assert_in_delta expected_payout, seller.wallet.balance - initial_seller_balance
  end

  test '#draw_winner! cancels and refunds if max tickets are not met but end date is met' do
    bob.wallet.update!(balance: 100_000)

    raffle = raffles(:iphone_giveaway)
    initial_balance = bob.wallet.balance

    raffle.buy_tickets(buyer: bob, quantity: raffle.max_tickets - 1)

    assert_not_equal initial_balance, bob.wallet.balance

    raffle.update!(end_date: 1.second.ago)

    winner = raffle.draw_winner!

    assert_operator raffle.raffle_tickets.count, :<, raffle.max_tickets
    assert_nil winner
    assert_predicate raffle, :cancelled?

    bob.wallet.reload

    assert_equal initial_balance, bob.wallet.balance
  end

  test '.eligible_for_draw returns raffles that have gone past their end date but do not have a winner' do
    raffle1 = raffles(:iphone_giveaway)
    raffle1.update!(end_date: 1.day.ago, winner: nil)

    raffle2 = Raffle.create!(valid_raffle_attributes)

    assert_includes Raffle.eligible_for_draw, raffle1
    assert_not_includes Raffle.eligible_for_draw, raffle2

    raffle1.draw_winner!

    assert_not_includes Raffle.eligible_for_draw, raffle1
  end

  test '.eligible_for_draw returns raffles that have sold maximum tickets but do not have a winner' do
    raffle = raffles(:iphone_giveaway)

    bob.wallet.update!(balance: 100_000)
    raffle.buy_tickets(buyer: bob, quantity: raffle.max_tickets)

    assert_includes Raffle.eligible_for_draw, raffle

    raffle.draw_winner!

    assert_not_includes Raffle.eligible_for_draw, raffle
  end

  test '#tickets_remaining' do
    raffle = raffles(:iphone_giveaway)

    assert_equal raffle.max_tickets, raffle.tickets_remaining

    raffle.buy_tickets(buyer: bob, quantity: 1)

    assert_equal raffle.max_tickets - 1, raffle.tickets_remaining
  end

  private

  def valid_raffle_attributes
    {
      user: leo,
      name: 'Apple Watch Series 12',
      general_description: 'Brand new smartwatch with fitness tracking and ECG.',
      condition_description: 'Factory sealed, never used.',
      whats_included_description: 'Includes charger and original packaging.',
      price: 899,
      ticket_price: 15,
      category: :tech,
      condition: :new,
      end_date: 14.days.from_now
    }
  end
end
