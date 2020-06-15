# frozen_string_literals: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :development)

dir_path = File.expand_path('lib', __dir__)

$LOAD_PATH << dir_path unless $LOAD_PATH.include?(dir_path)
Dir.glob('**/*.rb', base: 'lib').sort.each { |f| require f }

require 'date'
require 'time'

# # local imports
# require 'colors'
# require 'record'

VERSION = '1.0.0'
ISSUE_TRACKERS = %w[azure jira]

module Tt
  module Commands
    extend Dry::CLI::Registry

    class Purge < Dry::CLI::Command

    end

    register 'add', Command::Record, aliases: ['a']
    register 'report', Command::Report
  end
end

Dry::CLI.new(Tt::Commands).call
