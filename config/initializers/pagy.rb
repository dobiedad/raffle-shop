# frozen_string_literal: true

# Pagy initializer file

require 'pagy/extras/overflow'

Pagy::DEFAULT[:limit] = 9

Pagy::DEFAULT[:overflow] = :last_page

Pagy::DEFAULT[:max_limit] = 100
