# frozen_string_literal: true

class AddRelatedToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions, :related, polymorphic: true, null: true, index: true
  end
end
