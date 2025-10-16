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

    def pagination_series
      # Show max 7 page numbers (including ellipsis)
      max_pages = 7
      total_pages = pagy.pages
      current_page = pagy.page

      if total_pages <= max_pages
        # Show all pages if total is small
        (1..total_pages).to_a
      elsif current_page <= 4
        # Show smart pagination with ellipsis

        # Near the beginning: 1 2 3 4 5 ... last
        (1..5).to_a + ['...', total_pages]
      elsif current_page >= total_pages - 3
        # Near the end: 1 ... (last-4) (last-3) (last-2) (last-1) last
        [1, '...'] + ((total_pages - 4)..total_pages).to_a
      else
        # In the middle: 1 ... (current-1) current (current+1) ... last
        [1, '...', current_page - 1, current_page, current_page + 1, '...', total_pages]

      end
    end
  end
end
