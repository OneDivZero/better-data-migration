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
