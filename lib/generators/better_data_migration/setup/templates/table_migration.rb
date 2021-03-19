class CreateAppMigrations < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :app_migrations do |t|
      t.string :name, null: false
      t.boolean :applied, null: false, default: false

      t.timestamps
    end
  end
end
