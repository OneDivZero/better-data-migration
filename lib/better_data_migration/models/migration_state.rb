# == Schema Information
#
# Table name: app_migrations
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  applied    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module BetterDataMigration
  class MigrationState < ActiveRecord::Base
    class MigrationNotFoundError < StandardError; end

    self.table_name = BetterDataMigration::MIGRATION_TABLE_NAME

    # alt: 2714, 2715, 2612, 2757
    OK_SYMBOL = "\u2705".freeze
    NOK_SYMBOL = "\u2757".freeze

    MIGRATION_PATH = BetterDataMigration::MIGRATION_PATH

    attr_accessor :migration_class, :required

    scope :ordered, -> { order(:id) }
    scope :migrated, -> { where(applied: true).ordered }
    scope :pending, -> { where(applied: false).ordered }

    validates :name, presence: true

    def not_applied?
      !applied
    end

    def state_symbol
      applied? ? OK_SYMBOL : NOK_SYMBOL
    end

    def file_name
      "#{id}_#{name.underscore}"
    end

    def file_path
      # PATH = Rails.root.join('db/data').freeze
      # App::Migrator::PATH.join("#{file_name}.rb")
      MIGRATION_PATH + "/#{file_name}.rb"
    end

    def migration_class_name
      "#{name}Migration"
    end

    def to_class
      @migration_class ||= migration_class_name.constantize
    rescue NameError
      puts "WARNING: Migration-Class not found '#{migration_class_name}'"
    end

    def to_s
      file_name
    end

    def require_migration
      @required ||= require file_path

      return true if Object.const_defined?(migration_class_name)

      raise MigrationNotFoundError
    rescue LoadError => _e
      puts "WARNING: Migration-File not found #{file_path}"
    end

    def description
      require_migration
      to_class.const_get('DESCRIPTION')
    end

    def unattended?
      require_migration
      return false if to_class.nil?

      to_class.const_get('UNATTENDED')
    end

    def requires_confirmation?
      !unattended?
    end

    def unattended_value
      unattended? ? 'Y' : 'N'
    end

    def setup
      require_migration
      to_class.new.setup
    end

    def rollback
      require_migration
      to_class.new.rollback
    end
  end
end
