# frozen_string_literal: true

require "active_record"
require "sqlite3"
require "fileutils"

module Tormenta20
  # Database connection and setup management for Tormenta20.
  #
  # Configuration via environment variables:
  # - TORMENTA20_DB_MODE: "built_in" (default), "create_on_build", or "path"
  # - TORMENTA20_DB_PATH: Custom path (required when mode is "path")
  #
  # @example Using built-in database (default)
  #   # No configuration needed, uses pre-built database from gem
  #   require 'tormenta20'
  #
  # @example Creating database on build
  #   # Set before requiring the gem:
  #   # TORMENTA20_DB_MODE=create_on_build
  #
  # @example Using custom path
  #   # TORMENTA20_DB_MODE=path
  #   # TORMENTA20_DB_PATH=/my/custom/path.sqlite3
  module Database
    # Valid database modes
    MODES = %w[built_in create_on_build path].freeze

    class << self
      # @return [String] Current database mode
      def mode
        @mode ||= ENV.fetch("TORMENTA20_DB_MODE", "built_in")
      end

      # @return [String] Path to the SQLite database file
      def db_path
        @db_path ||= resolve_db_path
      end

      # Initialize and configure the database connection.
      #
      # @return [void]
      def setup
        validate_mode!
        @setup_done = true

        ensure_database_exists if mode == "create_on_build"
        connect_to_database
      end

      # Ensure database is connected, setting up if needed.
      #
      # @return [void]
      def ensure_connected
        setup unless @setup_done
      end

      # Check if database connection is active.
      #
      # @return [Boolean] true if connected, false otherwise
      def connected?
        @connected == true && ActiveRecord::Base.connected?
      rescue StandardError
        false
      end

      # Disconnect from the database.
      #
      # @return [void]
      def disconnect
        ActiveRecord::Base.remove_connection if connected?
        @connected = false
      end

      # Reset database by dropping and recreating it.
      #
      # @return [void]
      # @note This will delete all data in the database
      def reset
        disconnect
        File.delete(db_path) if File.exist?(db_path)
        ensure_database_exists
        connect_to_database
      end

      # Get the default database file path.
      #
      # @return [String] Absolute path to the default database file
      def default_db_path
        File.expand_path("../../../db/tormenta20.sqlite3", __dir__)
      end

      # Get the schema SQL file path.
      #
      # @return [String] Absolute path to the schema.sql file
      def schema_path
        File.expand_path("../../../db/schema.sql", __dir__)
      end

      private

      def resolve_db_path
        case mode
        when "path"
          ENV.fetch("TORMENTA20_DB_PATH") do
            raise ArgumentError, "TORMENTA20_DB_PATH is required when TORMENTA20_DB_MODE=path"
          end
        else
          default_db_path
        end
      end

      def validate_mode!
        return if MODES.include?(mode)

        raise ArgumentError, "Invalid TORMENTA20_DB_MODE: #{mode}. Valid: #{MODES.join(", ")}"
      end

      def connect_to_database
        return if connected?

        ActiveRecord::Base.establish_connection(
          adapter: "sqlite3",
          database: db_path,
          pool: 5,
          timeout: 5000
        )

        @connected = true
      end

      def ensure_database_exists
        db_dir = File.dirname(db_path)
        FileUtils.mkdir_p(db_dir) unless Dir.exist?(db_dir)

        return if File.exist?(db_path)

        SQLite3::Database.new(db_path).close
        run_schema if schema_exists?
        seed_database
      end

      def seed_database
        return if Seeder.seeded?

        Seeder.seed_all(verbose: false)
      end

      def schema_exists?
        File.exist?(schema_path)
      end

      def run_schema
        connect_to_database
        sql = File.read(schema_path)
        ActiveRecord::Base.connection.raw_connection.execute_batch(sql)
      end
    end
  end
end
