require 'test_helper'

class MigrationStateTest < ActiveSupport::TestCase
  setup do
    @model = BetterDataMigration::MigrationState.new
  end

  def test_it_does_something_useful
    assert true
  end
end
