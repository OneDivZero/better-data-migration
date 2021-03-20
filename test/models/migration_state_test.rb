require 'test_helper'

class MigrationStateTest < ActiveSupport::TestCase
  describe 'Model' do
    before do
      @model_class = BetterDataMigration::MigrationState
      @model = @model_class.new(name: 'Test', applied: false)
    end

    after do
      @model.destroy
    end

    it 'is a valid instance' do
      assert @model.valid?
      assert @model.save
    end

    it 'has constants for symbols' do
      assert @model_class.const_defined? 'OK_SYMBOL'
      assert @model_class.const_defined? 'NOK_SYMBOL'
    end

    describe 'Scopes' do
      it 'has an ordered-scopes' do
        assert_respond_to(@model_class, :ordered)
      end

      it 'has a migrated-scope' do
        assert_empty @model_class.migrated

        @model.update(applied: true)

        refute_empty @model_class.migrated
      end

      it 'has a pending-scope' do
        @model.update(applied: true)

        assert_empty @model_class.pending

        @model.update(applied: false)

        refute_empty @model_class.pending
      end
    end

    describe 'Methods for file-handling' do
      it 'provides a valid file-name based on id and name' do
        @model.save
        expected = "#{@model.id}_#{@model.name}".underscore
        assert_equal expected, @model.file_name
      end

      # TODO: Origin implementation uses Rails.root.join
      it 'provides a full file-path' do
        @model.save
        expected = "db/data/#{@model.id}_#{@model.name.underscore}.rb"

        assert_equal expected, @model.file_path
      end

      it 'returns the file-name when calling #to_s' do
        assert_equal @model.file_name, @model.to_s
      end
    end

    describe 'MigrationClass-Resolution' do
      it 'returns a valid name for a related migration-class' do
        expected = "#{@model.name}Migration"
        assert_equal expected, @model.migration_class_name
      end

      it 'returns a migration-class when calling #to_class' do
        assert Object.const_defined?('TestMigration')
        assert_equal TestMigration, @model.to_class
      end

      it 'returns nil if a migration-class is unknown when calling #to_class' do
        @model.update(name: 'Unknown')
        refute Object.const_defined?('UnknownMigration')
        assert_nil @model.to_class
      end
    end
  end
end
