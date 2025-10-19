# frozen_string_literal: true

module UI
  class RaffleListWithTabs < ApplicationViewComponent
    attribute :title
    attribute :subtitle
    attribute :title_size, default: 'is-2'
    attribute :user # The user whose raffles we're showing
    attribute :current_user # The viewing user (for badge logic)
    attribute :raffles
    attribute :pagy
    attribute :tab_filter
    attribute :status_filter
    attribute :tabs
    attribute :show_avatar, default: false

    def tab_active?(tab_name)
      tab_filter == tab_name
    end

    def status_active?(status)
      status_filter == status
    end

    def badge_text_for(raffle)
      if tab_filter == 'participating'
        badge_for_participating(raffle)
      else
        badge_for_created(raffle)
      end
    end

    private

    def badge_for_participating(raffle) # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
      ticket_count = raffle.raffle_tickets.where(user: current_user).count

      if status_filter == 'active'
        "#{ticket_count} ticket#{'s' if ticket_count > 1}"
      elsif status_filter == 'completed'
        if raffle.winner_id == current_user.id
          '🏆 You Won!'
        elsif raffle.cancelled?
          '❌ Cancelled'
        elsif raffle.winner
          "Winner: #{raffle.winner.email.split('@').first}"
        else
          'Completed'
        end
      end
    end

    def badge_for_created(raffle)
      return unless status_filter == 'completed'

      if raffle.completed? && raffle.winner
        "🏆 Winner: #{raffle.winner.email.split('@').first}"
      elsif raffle.cancelled?
        '❌ Cancelled'
      else
        'Completed'
      end
    end
  end
end
