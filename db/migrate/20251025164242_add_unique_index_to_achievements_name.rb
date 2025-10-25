# frozen_string_literal: true

class AddUniqueIndexToAchievementsName < ActiveRecord::Migration[8.1]
  def change
    add_index :achievements, :name, unique: true
  end
end
