# frozen_string_literal: true

class UserProfileStats
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user
  attribute :viewing_user

  def tickets_entered_count
    @tickets_entered_count ||= user.raffle_tickets.count
  end

  def total_spent
    @total_spent ||= user.raffle_tickets.sum(:price)
  end

  def raffles_won_count
    @raffles_won_count ||= user.raffles_won.count
  end

  def wallet_balance
    return nil unless own_profile?

    @wallet_balance ||= user.wallet.balance
  end

  def recent_activities
    @recent_activities ||= RecentActivities.build(user).activities
  end

  def own_profile?
    viewing_user.present? && user == viewing_user
  end
end
