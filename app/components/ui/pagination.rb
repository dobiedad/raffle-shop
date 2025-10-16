# frozen_string_literal: true

module UI
  class Pagination < ApplicationViewComponent
    attribute :pagy, required: true

    def render?
      pagy.pages > 1
    end

    def pagination_classes
      'pagination is-centered mt-6'
    end

    def page_link(page)
      if page == pagy.page
        %(<li><a class="pagination-link is-current" aria-label="Page #{page}" aria-current="page">#{page}</a></li>)
      else
        %(<li>#{link_to page, url_for(page: page), class: 'pagination-link', 'aria-label': "Go to page #{page}"}</li>)
      end
    end

    def render_pagination_item(item)
      if item.is_a?(Integer)
        page_link(item)
      else
        # Skip ellipsis completely - just show page numbers
        ''
      end
    end
  end
end
