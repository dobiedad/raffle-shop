# frozen_string_literal: true

class AddNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_column :users, :last_name, :string, null: false # rubocop:disable Rails/NotNullColumn
  end
end
