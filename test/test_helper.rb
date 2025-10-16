# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative 'coverage_helper'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require_relative 'support/controller_test_helper'
require_relative 'support/vcr'
require_relative 'validate_assertions'
require 'minitest/mock'

module ActiveSupport
  class TestCase
    include ActiveJob::TestHelper
    include ValidateAssertions

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    if ENV['COVERAGE']
      parallelize_setup do |worker|
        SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
      end

      parallelize_teardown do
        SimpleCov.result
      end
    end

    fixtures :all

    def bob
      users(:bob)
    end

    def leo
      users(:leo)
    end

    def iphone_giveaway
      raffles(:iphone_giveaway)
    end
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
    include ControllerTestHelper
  end
end

module ActionDispatch
  class SystemTestCase
    include Devise::Test::IntegrationHelpers

    Capybara.enable_aria_label = true
  end
end
