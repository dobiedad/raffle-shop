# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :wallet, null: false, foreign_key: true, index: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :direction, null: false
      t.string :transaction_type, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :transactions, :transaction_type
    add_index :transactions, :created_at
  end
end
