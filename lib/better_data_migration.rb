# frozen_string_literal: true

# TODO: begin .. rescue LoadError for development-dependencies
require 'pry'
require 'pry-alias'
require 'active_record'
require 'active_support'

require 'better_data_migration/version'
require 'better_data_migration/config'
require 'better_data_migration/migration'
require 'better_data_migration/models/migration_state'

module BetterDataMigration
end
