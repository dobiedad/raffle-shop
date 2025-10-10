# frozen_string_literal: true

class RemoveDescriptionFromRaffles < ActiveRecord::Migration[8.0]
  def change
    remove_column :raffles, :description, :text
  end
end
