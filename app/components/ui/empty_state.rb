# frozen_string_literal: true

module UI
  class EmptyState < ApplicationViewComponent
    attribute :icon, :string
    attribute :title, :string
    attribute :description, :string
    attribute :action
    attribute :title_size, default: 5
  end
end
