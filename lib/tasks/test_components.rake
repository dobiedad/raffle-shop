# frozen_string_literal: true

namespace :test do
  desc 'Run tests for ViewComponents'
  task components: :environment do
    sh 'rails test test/components'
  end
end
