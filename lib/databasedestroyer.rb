require 'sinatra/base'
require 'rack/cors'
require 'json'
require 'mysql2'

require_relative '../config/database_task_helper'
require_relative './helpers/database_helper'

DB_CONFIG = DatabaseDestroyer::DatabaseTaskHelper.get_string(DatabaseDestroyer::DatabaseTaskHelper.get_yaml(ENV['DB_YAML_FILE']), 'test') 

class DatabaseDestroyer < Sinatra::Base 
  set :database, "#{DB_CONFIG['adapter']}://#{DB_CONFIG['username']}:#{DB_CONFIG['password']}@#{DB_CONFIG['host']}:#{DB_CONFIG['port']}/#{DB_CONFIG['database']}"
  enable :logging

  helpers Sinatra::DatabaseHelper

  use Rack::Cors do 
    allow do 
      origins '*'
      resource '/*', methods: [:get, :put, :post, :delete, :options], headers: :any
    end
  end

  post '/destroy' do 
    yaml_data = DatabaseTaskHelper.get_yaml(ENV['DB_YAML_FILE'])
    client = Mysql2::Client.new(yaml_data['test'])

    nuke! client
    seed! client, JSON.parse(File.read(File.expand_path('../../config/seeds.json', __FILE__)))

    [204]
  end

  delete '/destroy' do 
    yaml_data = DatabaseTaskHelper.get_yaml(ENV['DB_YAML_FILE'])['test']
    yaml_data['database'] = 'test'
    client = Mysql2::Client.new(yaml_data)

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
