# frozen_string_literal: true

require_relative '../../../app/components/ui/page_header'

class PageHeaderPreview < ComponentPreview
  def default
    render UI::PageHeader.new(
      title: '🎟️ Current Raffles',
      subtitle: 'Enter raffles for the latest gadgets, collectibles, and more — starting from just $1 per ticket.'
    )
  end

  def with_different_title_and_subtitle_sizes
    render UI::PageHeader.new(
      title: '🎟️ Current Raffles',
      subtitle: 'Enter raffles for the latest gadgets, collectibles, and more — starting from just $1 per ticket.',
      title_size: 3,
      subtitle_size: 7
    )
  end
end
