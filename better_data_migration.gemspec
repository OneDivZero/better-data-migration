# frozen_string_literal: true

require_relative 'lib/better_data_migration/version'

Gem::Specification.new do |spec|
  spec.name          = 'better-data-migration'
  spec.version       = BetterDataMigration::VERSION
  spec.authors       = ['OneDivZero']
  spec.email         = []

  spec.summary       = 'Perform data-related migrations seperated from database-migrations for all rails-environments.'
  # spec.description   = 'Write a longer description or delete this line.'
  spec.homepage      = 'https://github.com/OneDivZero/better-data-migration'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  # spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/OneDivZero/better-data-migration'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 5.0.0'

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest-focus'
  spec.add_development_dependency 'minitest-rails'
  # Drops in Minitest::Spec superclass for ActiveSupport::TestCase
  # spec.add_development_dependency 'minitest-spec-rails'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-alias'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 12.0'
  # Required: "can't use Pry without Readline or a compatible library"
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sqlite3'

  s.post_install_message = File.read('UPGRADING') if File.exist?('UPGRADING')
end
