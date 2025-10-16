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

  def dismissible
    render UI::NotificationBanner.new(
      type: 'info',
      icon: '💡',
      title: 'Dismissible:',
      message: 'You can close this notification.',
      dismissible: true,
      centered: false
    )
  end

  def with_html_content
    render UI::NotificationBanner.new(type: 'danger', centered: false) do
      content_tag(:div, class: 'content') do
        content_tag(:p, '3 errors prevented saving:', class: 'has-text-weight-bold') +
          content_tag(:ul) do
            content_tag(:li, 'Name can\'t be blank') +
              content_tag(:li, 'Price must be greater than 0') +
              content_tag(:li, 'Ticket price must be between 2 and 100')
          end
      end
    end
  end

  def flash_success
    render UI::NotificationBanner.new(
      type: 'success',
      message: 'Raffle was successfully created.',
      dismissible: true,
      centered: false
    )
  end

  def flash_error
    render UI::NotificationBanner.new(
      type: 'danger',
      message: 'Unable to save your changes. Please try again.',
      dismissible: true,
      centered: false
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
