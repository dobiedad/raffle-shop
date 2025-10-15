# frozen_string_literal: true

class AddFieldsToRaffles < ActiveRecord::Migration[8.0]
  def change
    add_column :raffles, :status, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_column :raffles, :category, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_column :raffles, :condition, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_column :raffles, :end_date, :datetime, null: false # rubocop:disable Rails/NotNullColumn
  end
end
