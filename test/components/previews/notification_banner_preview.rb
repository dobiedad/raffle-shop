# frozen_string_literal: true

require_relative '../../../app/components/ui/notification_banner'

# This preview allows you to see the component in different states during development
class NotificationBannerPreview < ComponentPreview
  def info
    render UI::NotificationBanner.new(
      type: 'info',
      icon: '💡',
      title: 'Info:',
      message: 'This is an informational message.'
    )
  end

  def success
    render UI::NotificationBanner.new(
      type: 'success',
      icon: '✅',
      title: 'Success:',
      message: 'Your action was completed successfully!'
    )
  end

  def warning
    render UI::NotificationBanner.new(
      type: 'warning',
      icon: '⚠️',
      title: 'Warning:',
      message: 'Please review this important information.'
    )
  end

  def danger
    render UI::NotificationBanner.new(
      type: 'danger',
      icon: '❌',
      title: 'Error:',
      message: 'Something went wrong. Please try again.'
    )
  end

  def without_icon
    render UI::NotificationBanner.new(
      type: 'info',
      title: 'Note:',
      message: 'This notification has no icon.'
    )
  end

  def without_title
    render UI::NotificationBanner.new(
      type: 'info',
      icon: '💡',
      message: 'This notification has no title, just an icon and message.'
    )
  end

  def message_only
    render UI::NotificationBanner.new(
      type: 'info',
      message: 'This notification has only a message.'
    )
  end

  def not_centered
    render UI::NotificationBanner.new(
      type: 'info',
      icon: '💡',
      title: 'Tip:',
      message: 'This notification is left-aligned.',
      centered: false
    )
  end

  def not_light
    render UI::NotificationBanner.new(
      type: 'info',
      icon: '💡',
      title: 'Tip:',
      message: 'This notification uses solid colors.',
      light: false
    )
  end
end

