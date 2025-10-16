# frozen_string_literal: true

require 'ostruct'
require_relative '../../../app/components/ui/pagination'

# This preview allows you to see the component in different states during development
class PaginationPreview < ComponentPreview
  def default
    pagy = OpenStruct.new(page: 2, pages: 100)
    render UI::Pagination.new(pagy: pagy)
  end
end
