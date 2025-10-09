# frozen_string_literal: true

desc 'Downloads a database dump from the staging app, then runs db:migrate'

task test_migration: :environment do
  staging_dump_path = Rails.root.join('staging.dump')

  if staging_dump_path.exist?
    puts "Found #{staging_dump_path} -- Using existing dump..."
  else
    sh 'heroku pg:backups:capture -a lucky-raffle'
    sh "heroku pg:backups:download -a lucky-raffle -o #{staging_dump_path}"
  end
  begin
    sh "bin/pg_restore --verbose --clean --no-acl --no-owner -h localhost -d lucky_raffle_rails_development #{staging_dump_path}" # rubocop:disable Layout/LineLength
  rescue RuntimeError => e
    puts "Ingoring pg_restore error #{e}"
  end
  sh 'rails db:migrate'
end
