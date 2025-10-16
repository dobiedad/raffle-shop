# frozen_string_literal: true

require_relative '../../../app/components/ui/search_bar'

class SearchBarPreview < ComponentPreview
  def default
    render UI::SearchBar.new(url: '/search')
  end
end
