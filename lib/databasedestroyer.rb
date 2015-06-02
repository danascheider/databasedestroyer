require 'sinatra/base'
require 'rack/cors'
require 'json'
require 'mysql2'

require_relative '../config/database_task_helper'

DB_CONFIG = DatabaseDestroyer::DatabaseTaskHelper.get_string(ENV['DB_YAML_FILE'] || File.expand_path('../config/database.yml', __FILE__), 'test')

class DatabaseDestroyer < Sinatra::Base 
  set :database, "#{DB_CONFIG['adapter']}://#{DB_CONFIG['user']}:#{DB_CONFIG['password']}@#{DB_CONFIG['host']}:#{DB_CONFIG['port']}/#{DB_CONFIG['database']}"

  use Rack::Cors do 
    allow do 
      origins 'null', /localhost(.*)/
      resource '/*', methods: [:get, :put, :post, :delete, :options], headers: :any
    end
  end

  delete '/destroy' do 
    yaml_data = DatabaseTaskHelper.get_yaml(File.expand_path('../../config/database.yml', __FILE__))
    client = Mysql2::Client.new(yaml_data['test'])

    client.query('SET FOREIGN_KEY_CHECKS = 0')

    client.query('SHOW TABLES', as: :array).each do |table|
      client.query("TRUNCATE TABLE #{table[0]}")
    end

    client.query('SET FOREIGN_KEY_CHECKS = 1')

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

    seeds = JSON.parse(File.read(File.expand_path('../../config/seeds.json', __FILE__)))

    seeds.each do |table, models|
      models.each do |model|
        strings = model.values.map {|val| "'#{val}'"}
        columns = '(' + model.keys.join(',') + ')'
        values  = '(' + strings.join(',') + ')'

        query = "INSERT INTO #{table} #{columns} VALUES #{values}"
        puts "----- BEGIN QUERY -----"
        puts query
        puts "------ END QUERY ------"

        client.query("INSERT INTO #{table} #{columns} VALUES #{values}")
      end
    end

    [204]
  end
end
