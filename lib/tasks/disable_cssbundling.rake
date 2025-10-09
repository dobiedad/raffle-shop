# frozen_string_literal: true

# Override the cssbundling build task to skip yarn install
Rake::TaskManager.record_task_metadata = true

if Rake::Task.task_defined?('css:build')
  Rake::Task['css:build'].clear
  Rake::Task.define_task('css:build' => [])
end

# Also nuke the underlying build step from cssbundling-rails
if Rake::Task.task_defined?('css:install')
  Rake::Task['css:install'].clear
  Rake::Task.define_task('css:install' => [])
end
