# frozen_string_literal: true

class UserRafflesFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user
  attribute :tab, default: 'created'
  attribute :status, default: 'active'

  def scope
    if tab == 'participating'
      participating_raffles
    else
      created_raffles
    end
  end

  private

  def participating_raffles
    if status == 'completed'
      participated_raffle_ids = user.raffle_tickets.pluck(:raffle_id).uniq
      Raffle.where(id: participated_raffle_ids)
            .where(status: %i[completed cancelled])
            .order(completed_at: :desc)
    else
      user.raffles_entered.active.distinct.order(created_at: :desc)
    end
  end

  def created_raffles
    if status == 'completed'
      user.raffles.where(status: %i[completed cancelled]).order(completed_at: :desc)
    else
      user.raffles.where(status: :active).order(created_at: :desc)
    end
  end
end
