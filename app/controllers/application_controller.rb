# frozen_string_literal: true

require 'application_responder'

class ApplicationController < ActionController::Base
  include Pagy::Backend

  self.responder = ApplicationResponder
  respond_to :html

  allow_browser versions: :modern
end
