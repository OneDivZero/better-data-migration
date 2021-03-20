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

    attr_accessor :migration_class, :required

    scope :ordered, -> { order(:id) }
    scope :migrated, -> { where(applied: true).ordered }
    scope :pending, -> { where(applied: false).ordered }

    validates :name, presence: true
  end
end
