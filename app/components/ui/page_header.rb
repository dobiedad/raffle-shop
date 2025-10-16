# frozen_string_literal: true

module UI
  class PageHeader < ApplicationViewComponent
    attribute :title
    attribute :subtitle

    def title?
      title.present?
    end

    def subtitle?
      subtitle.present?
    end
  end
end

