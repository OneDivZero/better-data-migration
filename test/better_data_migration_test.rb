# frozen_string_literal: true

require 'test_helper'

# class BetterDataMigrationTest < Minitest::Test
class BetterDataMigrationTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::BetterDataMigration::VERSION
  end

  def test_it_does_something_useful
    assert true
  end

  # it 'works' do
  #   assert true
  # end
end
