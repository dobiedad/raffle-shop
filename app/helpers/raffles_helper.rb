# frozen_string_literal: true

module RafflesHelper
  def status_tag_class(raffle)
    { active: 'is-success is-light', completed: 'is-info is-light', cancelled: 'is-danger is-light' }
      .fetch(raffle.status.to_sym, :info)
  end

  def trusted_seller?(user)
    user.raffles.count >= 3
  end

  def tickets_sold_display(raffle)
    raffle.tickets_sold_count || 0
  end

  def progress_percentage(raffle)
    sold = raffle.tickets_sold_count || 0
    max = raffle.max_tickets
    return 0 if max.zero?

    ((sold.to_f / max) * 100).round
  end
end
