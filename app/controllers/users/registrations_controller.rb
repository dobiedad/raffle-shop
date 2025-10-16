# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:profile_image])
    end

    def after_update_path_for(_resource)
      profile_path
    end
  end
end
