# frozen_string_literal: true

# Controller for displaying ViewComponent previews in the styleguide
class StyleguideController < ApplicationController
  include ViewComponent::PreviewActions

  helper_method :preview_label, :example_label

  private

  def preview_label(preview)
    preview.preview_name.titleize.gsub(' Component', '')
  end

  def example_label(example)
    example.humanize(capitalize: false)
  end
end
