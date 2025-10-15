# frozen_string_literal: true

class AddFieldsToRaffles < ActiveRecord::Migration[8.0]
  def change
    add_column :raffles, :status, :string, default: 'active'
    add_column :raffles, :category, :string
    add_column :raffles, :condition, :string
    add_column :raffles, :end_date, :datetime
  end
end
