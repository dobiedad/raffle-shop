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

  def profile_with_no_activity
    user = User.find_or_create_by!(
      email: 'newuser@example.com'
    )

    render UI::UserProfile.new(
      user: user,
      current_user: User.first,
      tickets_entered_count: 0,
      total_spent: 0,
      raffles_won_count: 0,
      wallet_balance: nil,
      recent_activities: []
    )
  end
end
