# frozen_string_literal: true

module UI
  class NotificationBanner < ApplicationViewComponent
    attribute :message, required: true
    attribute :title
    attribute :icon
    attribute :type, default: 'info'
    attribute :light, default: true
    attribute :centered, default: true

    def notification_classes
      classes = ['notification']
      classes << "is-#{type}"
      classes << 'is-light' if light
      classes << 'has-text-centered' if centered
      classes << 'mb-6'
      classes.join(' ')
    end

    def has_title?
      title.present?
    end

    def has_icon?
      icon.present?
    end
  end
end

