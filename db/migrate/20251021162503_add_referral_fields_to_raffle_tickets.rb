# frozen_string_literal: true

class AddReferralFieldsToRaffleTickets < ActiveRecord::Migration[8.0]
  def change
    add_reference :raffle_tickets, :referred_user, foreign_key: { to_table: :users }, index: true

    add_index :raffle_tickets, %i[user_id referred_user_id],
              unique: true,
              name: 'index_raffle_tickets_on_user_and_referred_user',
              where: 'referred_user_id IS NOT NULL'
  end
end
