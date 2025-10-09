# frozen_string_literal: true

class CreateRaffles < ActiveRecord::Migration[8.0]
  def change
    create_table :raffles do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
