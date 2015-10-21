require 'yaml'

class DatabaseDestroyer < Sinatra::Base
  module DatabaseTaskHelper
    def self.get_yaml(file)
      yaml = YAML.load_file(file)
      yaml['test'] = yaml['test'].to_h

      yaml
    end

    # Example:
    #     hash = DatabaseTaskHelper.get_yaml('database.yml')['test']
    #     DatabaseTaskHelper.get_string(hash, 'test')
    #         # => "mysql2://root:rootpassword@localhost:3306/test"

    def self.get_string(hash, env)
      "#{hash['adapter']}://#{hash['username']}:#{hash['password']}@#{hash['host']}:#{hash['port']}/#{env}"
    end
  end
end
