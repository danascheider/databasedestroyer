require 'yaml'
require 'json'
require 'mysql2'
require 'reactive_extensions/hash'

ENV['RACK_ENV']     = 'test'
ENV['DB_YAML_FILE'] = File.expand_path('../db.yml', __FILE__)

data = YAML.load_file(ENV['DB_YAML_FILE'])['test']

$client = Mysql2::Client.new(data)
$seeds = File.open(File.expand_path('../../../config/seeds.json', __FILE__), 'r+') {|file| JSON.parse(file.read) }

require 'rack/test'
require 'rspec/expectations'
require 'rspec/matchers'

require_relative '../../lib/databasedestroyer.rb'

class DatabaseDestroyerWorld
  include RSpec::Expectations
  include RSpec::Matchers
  include Rack::Test::Methods

  def app
    DatabaseDestroyer.new
  end
end

World do 
  DatabaseDestroyerWorld.new
end