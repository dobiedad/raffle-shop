# frozen_string_literal: true

require_relative '../../../app/components/ui/page_header'

class PageHeaderPreview < ComponentPreview
  def default
    render UI::PageHeader.new(
      title: '🎟️ Current Raffles',
      subtitle: 'Enter raffles for the latest gadgets, collectibles, and more — starting from just $1 per ticket.'
    )
  end

  def with_title_only
    render UI::PageHeader.new(
      title: '🎯 My Dashboard'
    )
  end

  def with_subtitle_only
    render UI::PageHeader.new(
      subtitle: 'Browse through our collection of amazing items'
    )
  end

  def simple_text
    render UI::PageHeader.new(
      title: 'Settings',
      subtitle: 'Manage your account preferences and notification settings.'
    )
  end
end
