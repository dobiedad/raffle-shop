# frozen_string_literal: true

require_relative '../../../app/components/ui/raffle_list_with_tabs'

class RaffleListWithTabsPreview < ComponentPreview
  def my_raffles_created
    user = User.first
    raffles = user.raffles.where(status: :active).order(created_at: :desc).limit(6)
    pagy = Pagy.new(count: raffles.count, page: 1, limit: 6)

    render UI::RaffleListWithTabs.new(
      title: '🎫 My Raffles',
      subtitle: "Manage your created raffles and track raffles you're participating in",
      user: user,
      current_user: user,
      raffles: raffles,
      pagy: pagy,
      tab_filter: 'created',
      status_filter: 'active',
      tabs: [
        {
          name: 'created',
          label: 'Created by Me',
          icon: '📝',
          path: '/my_created_raffles?status=active',
          active_path: '/my_created_raffles?status=active',
          completed_path: '/my_created_raffles?status=completed'
        },
        {
          name: 'participating',
          label: 'Participating In',
          icon: '🎟️',
          path: '/my_participating_raffles?status=active',
          active_path: '/my_participating_raffles?status=active',
          completed_path: '/my_participating_raffles?status=completed'
        }
      ]
    ) do
      <<~HTML.html_safe
        <div class="has-text-centered py-6" style="margin-top: 2rem;">
          <p class="is-size-4 mb-4">📭</p>
          <p class="is-size-5 has-text-grey-dark mb-3">You haven't created any active raffles</p>
          <p class="is-size-6 has-text-grey mb-5">Start a new raffle and reach thousands of potential participants</p>
          <a href="/raffles/new" class="button is-primary u-borderRadius50">Create Your First Raffle</a>
        </div>
      HTML
    end
  end

  def my_raffles_participating
    user = User.first
    raffles = user.raffles_entered.active.distinct.order(created_at: :desc).limit(6)
    pagy = Pagy.new(count: raffles.count, page: 1, limit: 6)

    render UI::RaffleListWithTabs.new(
      title: '🎫 My Raffles',
      subtitle: "Manage your created raffles and track raffles you're participating in",
      user: user,
      current_user: user,
      raffles: raffles,
      pagy: pagy,
      tab_filter: 'participating',
      status_filter: 'active',
      tabs: [
        {
          name: 'created',
          label: 'Created by Me',
          icon: '📝',
          path: '/my_created_raffles?status=active',
          active_path: '/my_created_raffles?status=active',
          completed_path: '/my_created_raffles?status=completed'
        },
        {
          name: 'participating',
          label: 'Participating In',
          icon: '🎟️',
          path: '/my_participating_raffles?status=active',
          active_path: '/my_participating_raffles?status=active',
          completed_path: '/my_participating_raffles?status=completed'
        }
      ]
    ) do
      <<~HTML.html_safe
        <div class="has-text-centered py-6" style="margin-top: 2rem;">
          <p class="is-size-4 mb-4">🎟️</p>
          <p class="is-size-5 has-text-grey-dark mb-3">You're not participating in any active raffles</p>
          <p class="is-size-6 has-text-grey mb-5">Browse active raffles and buy tickets to get started</p>
          <a href="/raffles" class="button is-primary u-borderRadius50">Browse Raffles</a>
        </div>
      HTML
    end
  end

  def user_raffles_with_avatar
    user = User.second
    current_user = User.first
    raffles = user.raffles.where(status: :active).order(created_at: :desc).limit(6)
    pagy = Pagy.new(count: raffles.count, page: 1, limit: 6)

    render UI::RaffleListWithTabs.new(
      title: "🎫 #{user.email}'s Raffles",
      subtitle: "Manage #{user.email}'s created raffles and track raffles they're participating in",
      title_size: 'is-3',
      user: user,
      current_user: current_user,
      raffles: raffles,
      pagy: pagy,
      tab_filter: 'created',
      status_filter: 'active',
      show_avatar: true,
      tabs: [
        {
          name: 'created',
          label: "Created by #{user.email.split('@').first}",
          icon: '📝',
          path: "/users/#{user.id}/raffles?tab=created&status=active",
          active_path: "/users/#{user.id}/raffles?tab=created&status=active",
          completed_path: "/users/#{user.id}/raffles?tab=created&status=completed"
        },
        {
          name: 'participating',
          label: 'Participating In',
          icon: '🎟️',
          path: "/users/#{user.id}/raffles?tab=participating&status=active",
          active_path: "/users/#{user.id}/raffles?tab=participating&status=active",
          completed_path: "/users/#{user.id}/raffles?tab=participating&status=completed"
        }
      ]
    ) do
      <<~HTML.html_safe
        <div class="box has-text-centered py-6">
          <p class="is-size-5 has-text-grey-dark mb-3">No active raffles</p>
          <p class="is-size-6 has-text-grey mb-4">This user hasn't created any active raffles yet.</p>
        </div>
      HTML
    end
  end
end
