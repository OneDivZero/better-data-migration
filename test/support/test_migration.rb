#--------------------------------------------------------------------------------
# NOTE: This require-statement is only required for internal gem-testing
require 'better_data_migration/migration'
#--------------------------------------------------------------------------------

# This is a sample migration-file which will be generated by this gem when the rails-generator is invoked.
class TestMigration < BetterDataMigration::Migration
  DESCRIPTION = ''.freeze
  UNATTENDED = true

  def initialize
    super
  end

  def setup
    # Your setup-code
  end

  def rollback
    # Your rollback-code
  end

  def summary
    puts 'TestMigration migrated'
  end
end
