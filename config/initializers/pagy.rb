# frozen_string_literal: true

# Pagy initializer file

require 'pagy/extras/overflow'

# Set default items per page
Pagy::DEFAULT[:limit] = 9

# Handle overflow (when page number exceeds available pages)
Pagy::DEFAULT[:overflow] = :last_page

# Optionally set max items per page
Pagy::DEFAULT[:max_limit] = 100

