# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :remove_profile_image_if_requested, only: [:update]

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile_image, :remove_profile_image])
  end

  def remove_profile_image_if_requested
    return unless params.dig(:user, :remove_profile_image) == '1'

    resource.profile_image.purge if resource.profile_image.attached?
    params[:user].delete(:remove_profile_image)
  end
end

