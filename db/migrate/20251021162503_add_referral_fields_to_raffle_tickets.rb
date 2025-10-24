# frozen_string_literal: true

class AddReferralFieldsToRaffleTickets < ActiveRecord::Migration[8.0]
  def change
    add_reference :raffle_tickets, :referred_user, foreign_key: { to_table: :users }, index: true
  end
end
