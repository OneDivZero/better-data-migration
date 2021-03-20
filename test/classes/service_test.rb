require 'test_helper'

module BetterDataMigration
  class ServiceTest < ActiveSupport::TestCase
    describe 'BetterDataMigration::Service' do
      before do
        @class = BetterDataMigration::Service
      end

      describe 'Database-Check' do
        # NOTE: Requires a mocked test too
        it 'checks the existence of the migration-table' do
          assert @class.migration_table_exists?
        end

        # NOTE: Requires a mocked test too
        it 'performs a database-check' do
          assert @class.check_database
        end
      end
    end
  end
end
