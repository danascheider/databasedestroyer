require 'sinatra/base'
require 'rack/cors'
require 'json'
require 'mysql2'

require_relative '../config/database_task_helper'
require_relative './helpers/database_helper'

DB_CONFIG = DatabaseDestroyer::DatabaseTaskHelper.get_string(ENV['DB_YAML_FILE'] || File.expand_path('../config/database.yml', __FILE__), 'test')

class DatabaseDestroyer < Sinatra::Base 
  set :database, "#{DB_CONFIG['adapter']}://#{DB_CONFIG['username']}:#{DB_CONFIG['password']}@#{DB_CONFIG['host']}:#{DB_CONFIG['port']}/#{DB_CONFIG['database']}"
  enable :logging

  helpers Sinatra::DatabaseHelper

  use Rack::Cors do 
    allow do 
      origins 'null', /localhost(.*)/, '24.21.101.216', /24.20.222.82(.*)/
      resource '/*', methods: [:get, :put, :post, :delete, :options], headers: :any
    end
  end

  delete '/destroy' do 
    yaml_data = DatabaseTaskHelper.get_yaml(File.expand_path('../../config/database.yml', __FILE__))
    client = Mysql2::Client.new(yaml_data['test'])

    nuke! client

    # The seeds.json file is set up like so:
    #     {
    #       <table>: [
    #         { ... },
    #         { ... },
    #         { ... }
    #       ],
    #       <table>: [
    #         { ... },
    #         { ... }
    #       ]
    #     }

    seed! client, JSON.parse(File.read(File.expand_path('../../config/seeds.json', __FILE__)))

    [204]
  end
end
