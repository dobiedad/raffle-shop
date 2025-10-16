# frozen_string_literal: true

module PagyHelper
  include Pagy::Frontend

  # Custom Bulma pagination renderer
  def pagy_bulma_nav(pagy)
    html = +%(<nav class="pagination is-centered mt-6" role="navigation" aria-label="pagination">)
    html << %(<ul class="pagination-list">)

    pagy.series.each do |item|
      html << if item.is_a?(Integer)
                page_link(item, pagy)
              elsif item.is_a?(String)
                %(<li><span class="pagination-ellipsis">&hellip;</span></li>)
              end
    end

    html << %(</ul></nav>)
    html.html_safe
  end

  private

  def page_link(page, pagy)
    if page == pagy.page
      %(<li><a class="pagination-link is-current" aria-label="Page #{page}" aria-current="page">#{page}</a></li>)
    else
      %(<li>#{link_to page, url_for(page: page), class: 'pagination-link', 'aria-label': "Go to page #{page}"}</li>)
    end
  end
end

