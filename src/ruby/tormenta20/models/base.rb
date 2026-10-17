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
    # page lookup, and {Concerns::LivroScoped}, which provides the +livro+
    # association and +.do_livro+ scope for filtering by source book.
    #
    # @abstract Subclass and set +table_name+ to create a new model
    #
    # @!attribute [rw] id
    #   @return [String] Unique string identifier (e.g. +"guerreiro"+, +"espada_longa"+)
    # @!attribute [rw] livro_id
    #   @return [String] Slug of the sourcebook this record was published in (default +"t20_eja"+)
    # @!attribute [r] created_at
    #   @return [Time] Record creation timestamp
    # @!attribute [r] updated_at
    #   @return [Time] Record last-update timestamp
    class Base < ActiveRecord::Base
      self.abstract_class = true

      include Concerns::BookReferenceable
      include Concerns::LivroScoped

      # Raised when any write operation is attempted on the Tormenta20 database.
      # The database is read-only by design — it ships as pre-built data.
      class ReadOnlyError < StandardError
        def initialize(msg = "Tormenta20 database is read-only")
          super
        end
      end

      # @!group Read-only enforcement

      class << self
        # @return [Boolean] true while {Tormenta20::Seeder} is populating a fresh database.
        #   Internal escape hatch: seeding is a legitimate write path, distinct from a
        #   consumer of the built gem mutating data.
        def seeding?
          Thread.current[:tormenta20_seeding] == true
        end
      end

      def readonly?
        !self.class.seeding?
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
