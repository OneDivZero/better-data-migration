module BetterDataMigration
  class Service
    class SetupError < StandardError; end

    DB_ERRORS = {
      no_db: '>> Please check database-connection',
      no_table: ">> Please check existense of table '#{MIGRATION_TABLE_NAME}'",
      unknown: '>> Unknown error occured'
    }.freeze

    # rubocop:disable Metrics/MethodLength
    def self.check_database
      begin
        ActiveRecord::Base.connection
        raise SetupError unless migration_table_exists?
      rescue ActiveRecord::NoDatabaseError
        print_error(:no_db)
      rescue SetupError
        print_error(:no_table)
      else
        return true
      end

      false
    end
    # rubocop:enable Metrics/MethodLength

    # NOTE: Old code-base
    # => rescue-handling ActiveRecord::StatementInvalid does not work as intended
    # => rescue-handling depends on postgres-gem :-(
    # def self.check_database
    #   begin
    #     ActiveRecord::Base.connection
    #     raise ActiveRecord::StatementInvalid unless App::Migration.table_exists?
    #   rescue ActiveRecord::NoDatabaseError
    #     puts '>> Please check database-connection'
    #   rescue ActiveRecord::StatementInvalid => e
    #     puts '>> Please check existense of table "app_migrations"' if e.cause.is_a?(PG::UndefinedTable)
    #     puts '>> Unknown error occured' unless e.cause.is_a?(PG::UndefinedTable)
    #   else
    #     return true
    #   end

    #   false
    # end

    def self.print_error(key)
      puts DB_ERRORS[key]
    end

    def self.migration_table_exists?
      MigrationState.table_exists?
    end

    def self.postgres?
      Object.const_defined?('PG')
    end
  end
end
