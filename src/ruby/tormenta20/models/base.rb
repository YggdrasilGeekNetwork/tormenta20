# frozen_string_literal: true

require "active_record"

module Tormenta20
  # Contains all ActiveRecord models for Tormenta20 data.
  module Models
    # Abstract base class for all Tormenta20 models.
    #
    # All models in this library inherit from this class, which itself
    # inherits from ActiveRecord::Base. This provides common functionality
    # and ensures all models share the same database connection.
    #
    # Every concrete model adds {Concerns::BookReferenceable}, which provides
    # the {Concerns::BookReferenceable#book_reference} method for sourcebook
    # page lookup.
    #
    # @abstract Subclass and set +table_name+ to create a new model
    #
    # @!attribute [rw] id
    #   @return [String] Unique string identifier (e.g. +"guerreiro"+, +"espada_longa"+)
    # @!attribute [r] created_at
    #   @return [Time] Record creation timestamp
    # @!attribute [r] updated_at
    #   @return [Time] Record last-update timestamp
    class Base < ActiveRecord::Base
      self.abstract_class = true

      include Concerns::BookReferenceable

      # Raised when any write operation is attempted on the Tormenta20 database.
      # The database is read-only by design — it ships as pre-built data.
      class ReadOnlyError < StandardError
        def initialize(msg = "Tormenta20 database is read-only")
          super
        end
      end

      # @!group Read-only enforcement

      def readonly?
        true
      end

      def destroy
        raise ReadOnlyError
      end
      alias destroy! destroy

      WRITE_CLASS_METHODS = %i[
        create create!
        insert insert! insert_all insert_all!
        upsert upsert_all
        update_all
        delete delete_all
        destroy_all
      ].freeze

      WRITE_CLASS_METHODS.each do |m|
        define_singleton_method(m) { |*| raise ReadOnlyError }
      end

      # @!endgroup
    end
  end
end
