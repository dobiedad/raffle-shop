# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.default_cassette_options = {
    record: :once,
    match_requests_on: %i[method uri body]
  }

  # Allow real HTTP connections for certain hosts if needed
  config.ignore_hosts '127.0.0.1', 'localhost'
end
