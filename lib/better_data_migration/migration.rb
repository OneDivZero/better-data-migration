module BetterDataMigration
  class Migration
    DESCRIPTION = ''.freeze
    UNATTENDED = false

    class RollbackNotPossible < StandardError; end

    def initialize; end

    def setup; end

    def rollback; end

    def summary; end
  end
end
