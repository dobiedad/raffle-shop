# frozen_string_literal: true

module UI
  class SearchBar < ApplicationViewComponent
    attribute :value
    attribute :url, required: true
    attribute :placeholder, default: 'Search...'
    attribute :button_text, default: 'Search'
    attribute :centered, default: true

    def form_classes
      classes = ['field', 'has-addons', 'search-bar-form']
      classes << 'has-addons-centered' if centered
      classes << 'mb-6'
      classes.join(' ')
    end

    def form_style
      centered ? 'margin: 0 auto;' : ''
    end
  end
end
