# frozen_string_literal: true

class AddAdminFieldsToRaffles < ActiveRecord::Migration[8.1]
  def change
    add_column :raffles, :auto_draw, :boolean, default: true, null: false
    add_column :raffles, :handed_over, :boolean, default: false, null: false
  end
end
