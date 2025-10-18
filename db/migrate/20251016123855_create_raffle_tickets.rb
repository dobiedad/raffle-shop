# frozen_string_literal: true

class CreateRaffleTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :raffle_tickets do |t|
      t.references :raffle, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.decimal :price, precision: 10, scale: 2, null: false
      t.datetime :purchased_at, null: false

      t.timestamps
    end

    add_index :raffle_tickets, %i[raffle_id user_id]
  end
end
