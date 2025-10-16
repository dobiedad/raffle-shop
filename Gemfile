# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Use Sass to process CSS
gem 'sass-rails', '~> 6.0'
# Bulma CSS framework
gem 'bulma-rails', '~> 0.9.4'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Authentication
gem 'devise'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache and Active Job
gem 'solid_cache'
gem 'solid_queue'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'awesome_print'
gem 'hashid-rails', '~> 1.0'
gem 'thruster', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.2'

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Code coverage
  gem 'simplecov', require: false

  # Testing utilities
  gem 'mocha'
  gem 'rails-controller-testing'
  gem 'vcr'
  gem 'webmock'

  # System testing
  gem 'byebug'
  gem 'rubocop-capybara', require: false
end

group :development do
  gem 'minitest-stub_any_instance'
  gem 'minitest-stub-const'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

gem 'responders'
gem 'rubocop', '~> 1.81'
gem 'rubocop-minitest', '~> 0.38.2'
gem 'rubocop-rails', '~> 2.33'

gem 'active_storage_validations', '~> 3.0'

# View Components
gem 'view_component'

# Syntax highlighting for styleguide
gem 'coderay'
gem 'method_source'

# Search
gem 'ransack'

# Pagination
gem 'pagy', '~> 9.0'
