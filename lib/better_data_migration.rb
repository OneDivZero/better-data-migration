# frozen_string_literal: true

require 'better_data_migration/version'

# TODO: begin .. rescue LoadError for development-dependencies
require 'pry'
require 'pry-alias'
require 'active_support'

module BetterDataMigration
  class Error < StandardError; end
  # Your code goes here...
end
