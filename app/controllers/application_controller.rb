# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  include Pagy::Backend

  self.responder = ApplicationResponder
  respond_to :html

  allow_browser versions: :modern

  before_action :store_user_location!, if: :storable_location?

  helper_method :platform_total_raised, :platform_total_tickets, :tickets_sold_today

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def platform_total_raised
    @platform_total_raised ||= Raffle.joins(:raffle_tickets)
                                     .where(raffle_tickets: RaffleTicket.purchased)
                                     .sum('raffle_tickets.price')
  end

  def platform_total_tickets
    @platform_total_tickets ||= RaffleTicket.purchased.count
  end

  def tickets_sold_today
    @tickets_sold_today ||= RaffleTicket.purchased
                                        .where(purchased_at: Date.current.all_day)
                                        .count
  end
end
