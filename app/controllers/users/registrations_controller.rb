# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name profile_image])
    end

    def after_update_path_for(_resource)
      profile_path
    end

    def build_resource(hash = {})
      super
      return unless params[:user] && params[:user][:referrer_code].present?

      referrer = User.find_by(referral_code: params[:user][:referrer_code])
      resource.referred_by = referrer if referrer
    end
  end
end
