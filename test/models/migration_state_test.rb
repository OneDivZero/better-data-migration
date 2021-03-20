require 'test_helper'

module BetterDataMigration
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

      it 'has a MigrationNotFoundError error defined' do
        assert @model_class.const_defined?('MigrationNotFoundError')
        assert_equal StandardError, @model_class::MigrationNotFoundError.superclass
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
        before do
          @model.save
        end

        it 'provides a valid file-name based on id and name' do
          @model.save
          expected = "#{@model.id}_#{@model.name}".underscore
          assert_equal expected, @model.file_name
        end

        # TODO: Origin implementation uses Rails.root.join
        # Checkout: lib/better_data_migration/config.rb for more details
        it 'provides a full file-path' do
          @model.save
          expected = BetterDataMigration.migration_files_path + "/#{@model.id}_#{@model.name.underscore}.rb"

          assert_equal expected, @model.file_path
        end

        it 'returns the file-name when calling #to_s' do
          assert_equal @model.file_name, @model.to_s
        end
      end

      describe 'MigrationClass-Resolution' do
        before do
          @model.save

          @test_migration_file_path = "#{gem_root}/test/support/test_migration.rb"
          FileUtils.cp(@test_migration_file_path, @model.file_path)
        end

        after do
          @model.update(name: 'Test') if @model.name.eql?('Unknown') # otherwise file origin-file stays in 'db/data'
          File.delete(@model.file_path) if File.exist?(@model.file_path)
        end

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

        it 'catches a name-error if a migration-class is unknown when calling #to_class' do
          @model.update(name: 'Unknown')
          @model.to_class
          assert @model.name_error
        end

        it 'can require a migration-class and preserves state of requiring the related migration-file' do
          assert_nil @model.required
          assert @model.require_migration
          assert @model.required
        end

        it 'catches a load-error when requiring a migration-class' do
          @model.update(name: 'Unknown')
          @model.require_migration
          assert @model.load_error
        end

        it 'raises MigrationNotFoundError if the file exists, but the migration-class is undefined' do
          @model.update(name: 'Unknown')

          # Rename the copied test-migration from before-block (still defined as: class TestMigration)
          old_file_path = BetterDataMigration.migration_files_path + "/#{@model.id}_test.rb"
          File.rename(old_file_path, @model.file_path)

          assert_raises(BetterDataMigration::MigrationState::MigrationNotFoundError) { @model.require_migration }

          # Additional cleanup required only for this test-case (after-block does not catch this case)
          File.delete(@model.file_path) if File.exist?(@model.file_path)
        end
      end

      # TODO: We should use better of mocking for underlying 'class TestMigration' in some of the upcoming test-cases
      describe 'MigrationClass-Delegation' do
        before do
          @model.save

          @test_migration_file_path = "#{gem_root}/test/support/test_migration.rb"
          FileUtils.cp(@test_migration_file_path, @model.file_path)
        end

        after do
          File.delete(@model.file_path) if File.exist?(@model.file_path)
        end

        # TODO: This test is not a good evidence, cause it depends on value of DESCRIPTION in class TestMigration
        it 'returns the value of description from migration-class' do
          assert_equal 'DESCRIPTION', @model.description
        end

        # TODO: This test is not a good evidence, cause it depends on value of UNATTENDED in class TestMigration
        it 'returns the value of unattended from migration-class' do
          assert_equal true, @model.unattended?
        end

        # TODO: This test is not a good evidence, cause it depends on :unattended? which depends on value of
        # UNATTENDED in class TestMigration
        it 'replies if the migration requires confirmation' do
          refute @model.requires_confirmation?
        end

        # TODO: This test is not a good evidence, cause it depends on :unattended? which depends on value of
        # UNATTENDED in class TestMigration
        it 'replies with a value when calling #unattended_value' do
          assert_equal 'Y', @model.unattended_value
        end
      end

      # TODO: These test do not make really sense
      describe 'MigrationClass-Invocation' do
        it 'has methods for migration-class-invocation' do
          assert_respond_to @model, :setup
          assert_respond_to @model, :rollback
        end

        it 'can invoke #setup' do
          assert_nil @model.setup
        end

        it 'can invoke #rollback' do
          assert_nil @model.rollback
        end
      end
    end
  end
end
