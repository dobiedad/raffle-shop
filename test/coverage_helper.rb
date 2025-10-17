# frozen_string_literal: true

coverage_mode = ENV['COVERAGE']

if coverage_mode
  require 'simplecov'

  SimpleCov.command_name(coverage_mode)

  SimpleCov.start 'rails' do
    formatter SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::SimpleFormatter,
        SimpleCov::Formatter::HTMLFormatter
      ]
    )

    add_filter 'app/lib/'
    add_filter 'lib/rails/generators/'
    add_filter 'app/channels'
    add_filter 'app/mailers'
    add_filter 'app/jobs/application_job.rb'
    add_filter 'lib/rubo_cop'

    case coverage_mode
    when 'models'
      add_filter 'app/controllers/'
      add_filter 'app/components/'
      add_filter 'app/helpers/'
      add_filter 'app/lib'
      add_filter 'lib/application_responder'
      add_filter 'app/jobs/'
      add_filter 'app/models/concerns/status_enum'
    when 'controllers'
      add_filter 'app/models/'
      add_filter 'app/jobs/'
      add_filter 'app/components/'
    when 'jobs', 'job'
      add_filter 'app/controllers/'
      add_filter 'app/components/'
      add_filter 'app/helpers/'
      add_filter 'app/mailers/'
      add_filter 'app/channels/'
      add_filter 'app/lib/'
      add_filter 'lib/'
      add_filter 'app/models/'
    when 'components'
      add_filter 'app/controllers/'
      add_filter 'app/models/'
      add_filter 'app/helpers/'
      add_filter 'app/jobs/'
    end
  end

  SimpleCov.minimum_coverage line: 100
end
