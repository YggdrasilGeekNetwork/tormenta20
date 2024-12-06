# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]

# Database build task
desc "Build the SQLite database with all JSON data"
task :build_db do
  ruby "bin/build_db"
end

# Ensure database is built before gem packaging
Rake::Task[:build].enhance([:build_db])
