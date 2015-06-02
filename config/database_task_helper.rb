require 'yaml'

class DatabaseDestroyer < Sinatra::Base
  module DatabaseTaskHelper
    def self.get_yaml(file)
      yaml = (File.open(file, 'r+') {|file| YAML.load_file(file) }).to_h
      yaml['test'] = yaml['test'].to_h

      yaml
    end

    # Example:
    #     hash = DatabaseTaskHelper.get_yaml('database.yml')['test']
    #     DatabaseTaskHelper.get_string(hash, 'test')
    #         # => "mysql2://root:rootpassword@localhost:3306/test"

    def self.get_string(hash, env)
      string = ''
      string << "#{hash['adapter']}://"
      string << "#{hash['username']}:"
      string << "#{hash['password']}@"
      string << "#{hash['host']}:"
      string << "#{hash['port']}/"
      string << env

      string
    end
  end
end