require 'test_helper'

class MigrationStateTest < ActiveSupport::TestCase
  describe 'Model' do
    before do
      @model_class = BetterDataMigration::MigrationState
      @model = @model_class.new(name: 'test', applied: false)
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
  end
end
