module BetterDataMigration
  class MigrationState < ActiveRecord::Base
    self.table_name = BetterDataMigration::MIGRATION_TABLE_NAME
  end
end
