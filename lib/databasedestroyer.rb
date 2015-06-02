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
      client.query("TRUNCATE TABLE #{table}")
    end

    client.query('SET FOREIGN_KEY_CHECKS = 1')

    seeds = JSON.parse(File.read(File.expand_path('../../config/seeds.json', __FILE__)), symbolize_names: true)

    user_attributes = seeds[:user]
    tasks = seeds[:tasks]

    user = User.create(user_attributes)

    tasks.each do |obj|
      obj[:task_list_id] = user.default_task_list.id
      obj[:owner_id] = user.id
      Task.create(obj)
    end

    [204]
  end
end
