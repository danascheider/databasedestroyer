require 'sinatra/base'
require 'rack/cors'
require 'mysql2'

require_relative '../config/database_task_helper'

class DatabaseDestroyer < Sinatra::Base 

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
    client.query('TRUNCATE TABLE tasks')
    client.query('TRUNCATE TABLE task_lists')
    client.query('TRUNCATE TABLE users')
    client.query('TRUNCATE TABLE organizations')
    client.query('TRUNCATE TABLE programs')
    client.query('TRUNCATE TABLE seasons')
    client.query('TRUNCATE TABLE auditions')
    client.query('TRUNCATE TABLE listings')
    client.query('SET FOREIGN_KEY_CHECKS = 1')

    seeds = JSON.parse(File.read(File.expand_path('../../../db/seeds.json', __FILE__)), symbolize_names: true)

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