# frozen_string_literal: true

module RafflesHelper
  def status_tag_class(raffle)
    { active: 'is-success is-light', completed: 'is-info is-light', cancelled: 'is-danger is-light' }
      .fetch(raffle.status.to_sym, :info)
  end

  def trusted_seller?(user)
    user.raffles.count >= 3
  end
end
