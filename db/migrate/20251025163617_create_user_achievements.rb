# frozen_string_literal: true

class CreateUserAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :user_achievements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :achievement, null: false, foreign_key: true
      t.datetime :earned_at, null: false

      t.timestamps
    end

    add_index :user_achievements, %i[user_id achievement_id], unique: true
    add_index :user_achievements, :earned_at
  end
end
