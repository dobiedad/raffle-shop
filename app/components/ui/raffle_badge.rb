# frozen_string_literal: true

module UI
  class RaffleBadge < ApplicationViewComponent
    attribute :text, required: true
    attribute :variant, default: :default

    def initialize(text:, variant: :default, **options)
      super
      @text = text
      @variant = variant
    end

    def badge_classes
      base_classes = 'raffle-badge'
      variant_classes = case variant
                        when :success
                          'raffle-badge--success'
                        when :warning
                          'raffle-badge--warning'
                        when :danger
                          'raffle-badge--danger'
                        else
                          'raffle-badge--default'
                        end

      "#{base_classes} #{variant_classes}"
    end

    def icon
      case variant
      when :success
        '✅'
      when :warning
        '⚠️'
      when :danger
        '❌'
      else
        '🎟️'
      end
    end
  end
end
