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

    test 'should set referred_by when valid referrer_code is provided' do
      sign_out @user
      referrer = users(:leo)

      assert_difference 'User.count', 1 do
        post user_registration_path, params: {
          user: {
            first_name: 'New',
            last_name: 'User',
            email: 'newuser@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            referrer_code: referrer.referral_code
          }
        }
      end

      new_user = User.find_by(email: 'newuser@example.com')

      assert_not_nil new_user
      assert_equal referrer, new_user.referred_by
    end

    test 'should not set referred_by when invalid referrer_code is provided' do
      sign_out @user

      assert_difference 'User.count', 1 do
        post user_registration_path, params: {
          user: {
            first_name: 'New',
            last_name: 'User',
            email: 'newuser2@example.com',
            password: 'password123',
            password_confirmation: 'password123',
            referrer_code: 'INVALID_CODE'
          }
        }
      end

      new_user = User.find_by(email: 'newuser2@example.com')

      assert_not_nil new_user
      assert_nil new_user.referred_by
    end

    test 'should not set referred_by when no referrer_code is provided' do
      sign_out @user

      assert_difference 'User.count', 1 do
        post user_registration_path, params: {
          user: {
            first_name: 'New',
            last_name: 'User',
            email: 'newuser3@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        }
      end

      new_user = User.find_by(email: 'newuser3@example.com')

      assert_not_nil new_user
      assert_nil new_user.referred_by
    end
  end
end
