# frozen_string_literal: true

module UI
  class UserProfile < ApplicationViewComponent
    attribute :user
    attribute :current_user
    attribute :tickets_entered_count
    attribute :total_spent
    attribute :raffles_won_count
    attribute :wallet_balance
    attribute :recent_activities

    def own_profile?
      current_user.present? && user == current_user
    end

    def action_buttons
      if own_profile?
        [
          { label: 'My Raffles', path: helpers.my_created_raffles_path, class: 'is-primary' },
          { label: 'My Tickets', path: helpers.my_tickets_path, class: 'is-success' },
          { label: 'Edit Profile', path: helpers.edit_user_registration_path, class: 'is-light' }
        ]
      else
        [] # Follow button will be added separately via helper
      end
    end

    def show_wallet?
      own_profile?
    end

    def recent_activity_empty_message
      if own_profile?
        'Your ticket purchases and raffle entries will appear here'
      else
        "This user hasn't participated in any raffles yet"
      end
    end

    def show_activity_link?
      own_profile?
    end
  end
end
