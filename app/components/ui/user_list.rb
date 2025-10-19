# frozen_string_literal: true

module UI
  class UserList < ApplicationViewComponent
    attribute :title, :string
    attribute :subtitle, :string
    attribute :users, default: []
    attribute :pagy, default: nil
    attribute :show_follow_button, :boolean, default: false
    attribute :empty_title, :string, default: 'No users found'
    attribute :empty_subtitle, :string, default: nil
    attribute :empty_cta, default: nil
  end
end
