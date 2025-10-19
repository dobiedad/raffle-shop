# frozen_string_literal: true

require_relative '../../../app/components/ui/user_profile'

class UserProfilePreview < ComponentPreview
  def own_profile
    user = User.first

    render UI::UserProfile.new(
      user: user,
      current_user: user,
      tickets_entered_count: user.raffle_tickets.count,
      total_spent: user.raffle_tickets.sum(:price),
      raffles_won_count: user.raffles_won.count,
      wallet_balance: user.wallet&.balance || 0,
      recent_activities: RecentActivities.build(user).activities
    )
  end

  def public_profile
    user = User.second
    current_user = User.first

    render UI::UserProfile.new(
      user: user,
      current_user: current_user,
      tickets_entered_count: user.raffle_tickets.count,
      total_spent: user.raffle_tickets.sum(:price),
      raffles_won_count: user.raffles_won.count,
      wallet_balance: nil,
      recent_activities: RecentActivities.build(user).activities
    )
  end
end
