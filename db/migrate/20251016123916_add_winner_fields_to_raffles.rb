# frozen_string_literal: true

class AddWinnerFieldsToRaffles < ActiveRecord::Migration[8.0]
  def change
    add_reference :raffles, :winner, foreign_key: { to_table: :users }, index: true
    add_column :raffles, :drawn_at, :datetime
    add_column :raffles, :completed_at, :datetime
    add_column :raffles, :platform_fee_percent, :decimal
  end
end
