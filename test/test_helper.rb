# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'better_data_migration'

# require 'rails/test_help'
# require 'minitest/rails'

require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/spec'
require 'minitest/pride'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

load File.dirname(__FILE__) + '/schema.rb'
