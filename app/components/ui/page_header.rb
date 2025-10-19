# frozen_string_literal: true

module UI
  class PageHeader < ApplicationViewComponent
    attribute :title
    attribute :subtitle
    attribute :title_size, default: '2'
    attribute :subtitle_size, default: '5'
  end
end
