# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  include Pagy::Backend

  self.responder = ApplicationResponder
  respond_to :html

  allow_browser versions: :modern

  rescue_from Pagy::OverflowError, with: :redirect_to_last_page

  private

  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last), notice: 'Page number too high, showing last page instead.'
  end
end
