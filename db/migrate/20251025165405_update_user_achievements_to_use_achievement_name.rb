# frozen_string_literal: true

class UpdateUserAchievementsToUseAchievementName < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :user_achievements, :achievements
    remove_column :user_achievements, :achievement_id, :integer
    add_column :user_achievements, :achievement_name, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_index :user_achievements, :achievement_name
    add_index :user_achievements, %i[user_id achievement_name], unique: true
  end
end
