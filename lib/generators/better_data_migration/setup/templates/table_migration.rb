#class CreateAppMigrations < (ActiveRecord.version.release() < Gem::Version.new('5.2.0') ? ActiveRecord::Migration : ActiveRecord::Migration[5.2])

class CreateAppMigrations < ActiveRecord::Migration[6.0]
  def change
    create_table :app_migrations do |t|
      t.string :name, null: false
      t.boolean :applied, null: false, default: false

      t.timestamps
    end
  end
end
