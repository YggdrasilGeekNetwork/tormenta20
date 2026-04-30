# frozen_string_literal: true

if ENV["COVERAGE"]
  require "simplecov"
  require "simplecov-cobertura"
  SimpleCov.start do
    formatter SimpleCov::Formatter::CoberturaFormatter
    add_filter "/spec/"
    add_filter "/db/"
    add_filter "/bin/"
  end
end

require_relative "../../src/ruby/tormenta20"

Bundler.setup(:default, :test)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
