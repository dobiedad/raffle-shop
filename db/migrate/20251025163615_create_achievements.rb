# frozen_string_literal: true

class CreateAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :icon, null: false
      t.string :criteria_type, null: false
      t.integer :criteria_value, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :achievements, :criteria_type
    add_index :achievements, :active
  end
end
