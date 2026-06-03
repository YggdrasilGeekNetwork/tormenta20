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
    end
  end
end
