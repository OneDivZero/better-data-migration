require 'rails/generators/active_record'

module BetterDataMigration
  module Generators
    class SetupGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      argument :name, type: :string, default: 'create_app_migrations'

      # Create table-migration in migration-folder
      def generate_files
        puts 'BetterDataMigration::Setup invoked'
        puts "Creating table-migration for Rails#{migration_version}"
        migration_template 'table_migration.rb', "db/migrate/#{name}.rb"
      end

      def rails5_and_up?
        Rails::VERSION::MAJOR >= 5
      end

      def rails61_and_up?
        Rails::VERSION::MAJOR > 6 || (Rails::VERSION::MAJOR == 6 && Rails::VERSION::MINOR >= 1)
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
      end
    end
  end
end
