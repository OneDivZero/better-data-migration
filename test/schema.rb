ActiveRecord::Schema.define do
  self.verbose = false

  create_table BetterDataMigration::MIGRATION_TABLE_NAME, force: true do |t|
    t.string :name, null: false
    t.boolean :applied, null: false, default: false

    t.timestamps
  end
end
