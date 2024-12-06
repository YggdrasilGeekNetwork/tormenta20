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
    # @abstract Subclass and set table_name to create a new model
    class Base < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
