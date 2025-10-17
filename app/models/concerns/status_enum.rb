# frozen_string_literal: true

# Adds metadata support to ActiveRecord enums for displaying record status
module StatusEnum
  extend ActiveSupport::Concern

  module ClassMethods
    def status_enum(statuses_with_display_types)
      validate_display_types!(statuses_with_display_types.values)
      define_enum :status, statuses_with_display_types.keys.index_with(&:to_s)
      define_status_display_type_method(statuses_with_display_types)
      define_default_status(statuses_with_display_types.keys.first)
    end

    ALLOWED_DISPLAY_TYPES = %i[info warning danger success light primary].freeze

    def validate_display_types!(display_types)
      invalid = display_types - ALLOWED_DISPLAY_TYPES
      raise "Unexpected display types: #{invalid}" if invalid.any?
    end

    def define_status_display_type_method(mapping)
      define_method(:status_display_type) { mapping.fetch(status.to_sym) }
    end

    def define_default_status(default_status)
      after_initialize { self.status ||= default_status.to_s }
      validates :status, presence: true
    end
  end
end
