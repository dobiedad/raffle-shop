# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  include Pagy::Backend

  self.responder = ApplicationResponder
  respond_to :html

  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # :nocov:
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile_image])
  end

  # :nocov:
end
