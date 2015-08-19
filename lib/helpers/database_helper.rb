require 'mysql2'

module Sinatra
  module DatabaseHelper

    # Truncate all tables in the database using the Mysql2 client passed as an argument

    def nuke! client
      client.query('SET FOREIGN_KEY_CHECKS = 0')
 
      client.query('SHOW TABLES', as: :array).each do |table|
        client.query("TRUNCATE TABLE #{table[0]}")
      end
 
      client.query('SET FOREIGN_KEY_CHECKS = 1')
    end

    def seed! client, seeds
      seeds.each do |table, models|
        models.each do |model|
          strings = model.values.map {|val| val.is_a?(String) ? "'#{val}'" : val}
          columns = '(' + model.keys.join(',') + ')'
          values  = '(' + strings.join(',') + ')'
          client.query("INSERT INTO #{table} #{columns} VALUES #{values}")
        end
      end
    end
  end
end
