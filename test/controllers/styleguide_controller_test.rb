# frozen_string_literal: true

require 'test_helper'

class StyleguideControllerTest < ActionDispatch::IntegrationTest
  test 'all component previews can be visited' do
    ViewComponent::Preview.all.each do |preview| # rubocop:disable Rails/FindEach
      next if preview.preview_name == 'component'

      preview.examples.each do |example|
        get styleguide_preview_path("#{preview.preview_name}/#{example}")

        assert_response :success, "failed for #{preview.preview_name}/#{example}"
      end
    end
  end
end
