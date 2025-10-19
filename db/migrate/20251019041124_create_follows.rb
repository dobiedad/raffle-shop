# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followed, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :follows, %i[follower_id followed_id], unique: true
    add_index :follows, %i[followed_id created_at]
    add_index :follows, %i[follower_id created_at]
  end
end
