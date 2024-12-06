# frozen_string_literal: true

require "active_record"
require "sqlite3"
require "fileutils"

module Tormenta20
  # Database connection and setup management for Tormenta20.
  #
  # This module handles all database operations including connection management,
  # schema creation, and data seeding.
  #
  # @example Setup with default options
  #   Tormenta20::Database.setup
  #
  # @example Setup with custom database path
  #   Tormenta20::Database.setup(db_path: "/custom/path/tormenta20.sqlite3")
  module Database
    class << self
      # @!attribute [rw] mode
      #   @return [Symbol] Current database mode (:builtin, :build, or :lazy)
      attr_accessor :mode

      # @!attribute [rw] db_path
      #   @return [String] Path to the SQLite database file
      attr_accessor :db_path

      # Initialize and configure the database connection.
      #
      # @param mode [Symbol] Database initialization mode:
      #   - `:builtin` - Use pre-built database (connects immediately)
      #   - `:build` - Build database on load (creates if missing, then connects)
      #   - `:lazy` - Build database on first use (default)
      # @param db_path [String, nil] Custom path to SQLite database file.
      #   If nil, uses the default path.
      # @return [void]
      # @raise [ArgumentError] If an invalid mode is provided
      #
      # @example Default lazy setup
      #   Database.setup
      #
      # @example Immediate connection with builtin database
      #   Database.setup(mode: :builtin)
      def setup(mode: :lazy, db_path: nil)
        @mode = mode
        @db_path = db_path || default_db_path
        @setup_done = true

        case mode
        when :builtin
          connect_to_database
        when :build
          ensure_database_exists
          connect_to_database
        when :lazy
          # Connection will be established on first use via ensure_connected
          nil
        else
          raise ArgumentError, "Invalid mode: #{mode}. Use :builtin, :build, or :lazy"
        end
      end

      # Ensure database is connected, setting up if needed.
      #
      # This method is called automatically when models are accessed.
      # It handles lazy initialization of the database connection.
      #
      # @return [void]
      def ensure_connected
        setup unless @setup_done
        connect_to_database unless connected?
      end

      # Establish connection to the SQLite database.
      #
      # Creates the database if it doesn't exist (in lazy mode) and
      # establishes an ActiveRecord connection.
      #
      # @return [void]
      def connect_to_database
        return if connected?

        ensure_database_exists if mode == :lazy

        ActiveRecord::Base.establish_connection(
          adapter: "sqlite3",
          database: db_path,
          pool: 5,
          timeout: 5000
        )

        @connected = true
      end

      # Check if database connection is active.
      #
      # @return [Boolean] true if connected, false otherwise
      def connected?
        @connected == true && ActiveRecord::Base.connected?
      rescue StandardError
        false
      end

      # Ensure database file and schema exist.
      #
      # Creates the database directory, file, and runs the schema
      # if the database doesn't exist.
      #
      # @return [void]
      def ensure_database_exists
        db_dir = File.dirname(db_path)
        FileUtils.mkdir_p(db_dir) unless Dir.exist?(db_dir)

        needs_seed = !File.exist?(db_path)

        return unless needs_seed

        # Create empty database
        SQLite3::Database.new(db_path).close

        # Run schema if available
        run_schema if schema_exists?

        # Seed data after schema creation
        seed_database
      end

      # Seed database with data from JSON files.
      #
      # @return [void]
      def seed_database
        return if Seeder.seeded?

        Seeder.seed_all(verbose: false)
      end

      # Run pending database migrations.
      #
      # @return [void]
      def migrate
        connect_to_database
        ActiveRecord::MigrationContext.new(migrations_path, ActiveRecord::SchemaMigration).migrate
      end

      # Rollback database migrations.
      #
      # @param steps [Integer] Number of migrations to rollback
      # @return [void]
      def rollback(steps: 1)
        connect_to_database
        ActiveRecord::MigrationContext.new(migrations_path, ActiveRecord::SchemaMigration).rollback(steps)
      end

      # Get current database migration version.
      #
      # @return [Integer] Current migration version number
      def version
        connect_to_database
        ActiveRecord::Base.connection.migration_context.current_version
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

      # Disconnect from the database.
      #
      # @return [void]
      def disconnect
        ActiveRecord::Base.remove_connection if connected?
        @connected = false
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

      # Get the migrations directory path.
      #
      # @return [String] Absolute path to the migrations directory
      def migrations_path
        File.expand_path("../../../db/migrate", __dir__)
      end

      private

      # Check if schema file exists.
      #
      # @return [Boolean] true if schema.sql exists
      # @api private
      def schema_exists?
        File.exist?(schema_path)
      end

      # Run schema SQL file to create database tables.
      #
      # @return [void]
      # @api private
      def run_schema
        connect_to_database
        sql = File.read(schema_path)
        # Use execute_batch to handle multi-statement SQL including triggers
        ActiveRecord::Base.connection.raw_connection.execute_batch(sql)
      end
    end
  end
end
