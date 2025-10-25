class CreateRaffleViews < ActiveRecord::Migration[8.1]
  def change
    create_table :raffle_views do |t|
      t.references :raffle, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.datetime :viewed_at, null: false
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :raffle_views, [:raffle_id, :viewed_at]
    add_index :raffle_views, [:raffle_id, :user_id, :viewed_at], name: 'index_raffle_views_on_raffle_user_viewed'
  end
end
