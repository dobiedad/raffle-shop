# frozen_string_literal: true

module UI
  class NotificationBanner < ApplicationViewComponent
    attribute :message
    attribute :title
    attribute :icon
    attribute :type, default: 'info'
    attribute :light, default: true
    attribute :centered, default: true
    attribute :dismissible, default: false

    def notification_classes
      classes = ['notification']
      classes << "is-#{type}"
      classes << 'is-light' if light
      classes << 'has-text-centered' if centered
      classes << 'mb-0'
      classes.join(' ')
    end

    def title?
      title.present?
    end

    def icon?
      icon.present?
    end

    def message?
      message.present?
    end
  end
end
