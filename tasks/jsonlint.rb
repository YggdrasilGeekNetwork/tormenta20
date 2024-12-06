# frozen_string_literal: true

require "jsonlint/rake_task"
JsonLint::RakeTask.new do |t|
  t.paths = %w[
    spec/**/*.json
  ]
end
