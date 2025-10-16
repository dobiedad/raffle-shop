# frozen_string_literal: true

require_relative '../../../app/components/ui/badge'

# This preview allows you to see the component in different states during development
class BadgePreview < ComponentPreview
  def default
    render(UI::Badge.new(text: '3 tickets'))
  end

  def success
    render(UI::Badge.new(text: 'Won!', variant: :success))
  end

  def warning
    render(UI::Badge.new(text: 'Ending Soon', variant: :warning))
  end

  def danger
    render(UI::Badge.new(text: 'Cancelled', variant: :danger))
  end
end
