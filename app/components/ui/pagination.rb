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
      max_pages = 4
      total_pages = pagy.pages
      current_page = pagy.page

      if total_pages <= max_pages
        (1..total_pages).to_a
      elsif current_page <= 4
        (1..2).to_a + ['...', total_pages]
      elsif current_page >= total_pages - 3
        [1, '...'] + ((total_pages - 4)..total_pages).to_a
      else
        [1, '...', current_page - 1, current_page, current_page + 1, '...', total_pages]
      end
    end
  end
end
