# frozen_string_literal: true

module UI
  class SearchBar < ApplicationViewComponent
    attribute :value
    attribute :url, required: true
    attribute :param_name, default: 'q[name_cont]'
    attribute :placeholder, default: 'Search...'
    attribute :button_text, default: 'Search'
    attribute :centered, default: true
    attribute :preserve_params, default: []

    def form_classes
      classes = %w[field has-addons search-bar-form]
      classes << 'has-addons-centered' if centered
      classes << 'mb-6'
      classes.join(' ')
    end

    def form_style
      centered ? 'margin: 0 auto;' : ''
    end
  end
end
