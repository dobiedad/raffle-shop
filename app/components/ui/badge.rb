# frozen_string_literal: true

module UI
  class Badge < ApplicationViewComponent
    attribute :text, required: true
    attribute :variant, default: :default
    attribute :position, default: :inline

    def initialize(text:, variant: :default, position: :inline, **options)
      super
      @text = text
      @variant = variant
      @position = position
    end

    def badge_classes
      base_classes = 'badge'
      variant_classes = case variant
                       when :success
                         'badge--success'
                       when :warning
                         'badge--warning'
                       when :danger
                         'badge--danger'
                       else
                         'badge--default'
                       end
      
      position_classes = case position
                        when :absolute
                          'badge--absolute'
                        else
                          'badge--inline'
                        end

      "#{base_classes} #{variant_classes} #{position_classes}"
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
