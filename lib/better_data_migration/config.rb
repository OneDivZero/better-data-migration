module BetterDataMigration
  GEM_NAME = 'better-data-migration'.freeze
  MIGRATION_TABLE_NAME = 'app_migrations'.freeze
  MIGRATION_PATH = 'db/data'.freeze

  def self.root_path
    Gem::Specification.find_by_name(GEM_NAME).gem_dir
  end

  # TODO: Checkout if this does work inside app-context where the gem is used
  def self.migration_files_path
    current_root = rails_root_available? ? Rails.root.to_s : root_path
    [current_root, '/', MIGRATION_PATH].join
  end

  def self.rails_root_available?
    Object.const_defined?('Rails') && Rails.respond_to?(:root)
  end
end
