# frozen_string_literal: true

require_relative '../../../app/components/ui/empty_state'

class EmptyStatePreview < ComponentPreview
  def default
    render UI::EmptyState.new(
      title: 'No recent activity',
      description: 'Your ticket purchases and raffle entries will appear here'
    )
  end

  def with_action_button
    render UI::EmptyState.new(
      icon: '🎫',
      title: 'No active raffles',
      description: 'Create your own raffle or browse available ones',
      action: '
        <div class="buttons is-centered">
          <a href="#" class="button is-primary is-light">Create Raffle</a>
          <a href="#" class="button is-link is-light">Browse Raffles</a>
        </div>
      '.html_safe
    )
  end
end
