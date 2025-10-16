# frozen_string_literal: true

require 'test_helper'

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:bob)
      sign_in @user
    end

    test 'should redirect to profile page after successful update' do
      patch user_registration_path, params: {
        user: {
          email: @user.email,
          current_password: 'password123'
        }
      }

      assert_redirected_to profile_path
    end

    test 'should redirect to profile page after updating profile image' do
      image = fixture_file_upload(Rails.root.join('test/fixtures/files/leo.jpg'), 'image/jpeg')

      patch user_registration_path, params: {
        user: {
          email: @user.email,
          profile_image: image,
          current_password: 'password123'
        }
      }

      assert_redirected_to profile_path
    end

    test 'should redirect to profile page after password change' do
      patch user_registration_path, params: {
        user: {
          email: @user.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123',
          current_password: 'password123'
        }
      }

      assert_redirected_to profile_path
    end

    test 'should not redirect to profile page if update fails' do
      patch user_registration_path, params: {
        user: {
          email: 'invalid-email',
          current_password: 'wrongpassword'
        }
      }

      assert_response :unprocessable_entity
      assert_template 'devise/registrations/edit'
    end
  end
end
