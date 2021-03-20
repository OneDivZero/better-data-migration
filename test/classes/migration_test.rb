require 'test_helper'

module BetterDataMigration
  class MigrationTest < ActiveSupport::TestCase
    describe 'BetterDataMigration::Migration' do
      before do
        @class = BetterDataMigration::Migration
        @instance = @class.new
      end

      it 'has a RollbackNotPossible error defined' do
        assert @class.const_defined?('RollbackNotPossible')
        assert_equal StandardError, @class::RollbackNotPossible.superclass
      end

      describe 'Constants' do
        it 'has a constant for a description' do
          assert @class.const_defined?('DESCRIPTION')
          assert_empty @class::DESCRIPTION
        end

        it 'has a constant for an unattended-flag' do
          assert @class.const_defined?('UNATTENDED')
          assert_equal false, @class::UNATTENDED
        end
      end

      describe 'Lifecycle-Methods' do
        it 'has a setup-method' do
          assert_respond_to @instance, :setup
        end

        it 'has a rollback-method' do
          assert_respond_to @instance, :rollback
        end

        it 'has a summary-method' do
          assert_respond_to @instance, :summary
        end
      end
    end
  end
end
