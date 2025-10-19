# frozen_string_literal: true

class CreateUserActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :activity_type, null: false
      t.references :subject, polymorphic: true, null: false

      t.timestamps
    end

    add_index :user_activities, %i[user_id created_at]
    add_index :user_activities, %i[activity_type created_at]
  end
end
