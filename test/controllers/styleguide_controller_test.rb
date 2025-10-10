# frozen_string_literal: true

require 'test_helper'

class StyleguideControllerTest < ActionDispatch::IntegrationTest
  test 'all component previews can be visited' do
    ViewComponent::Preview.find_each do |preview|
      next if preview.preview_name == 'component'

      preview.examples.each do |example|
        get styleguide_preview_path("#{preview.preview_name}/#{example}")

        assert_response :success
      end
    end
  end
end
