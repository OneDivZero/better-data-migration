require 'rails/generators/active_record'

module BetterDataMigration
  module Generators
    #class SetupGenerator < ActiveRecord::Generators::NamedBase
    class SetupGenerator < ActiveRecord::Generators::Base
    #class SetupGenerator < ::Rails::Generators::Base

      source_root File.expand_path('templates', __dir__)

      argument :name, type: :string, default: 'create_app_migrations'

      # Create migration in project's folder
      def generate_files
        puts "BetterDataMigration::Setup invoked\n"
        migration_template 'table_migration.rb', "db/migrate/#{name}.rb"
      end
    end
  end
end
