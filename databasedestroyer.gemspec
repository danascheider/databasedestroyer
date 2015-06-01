require File.expand_path('../version.rb', __FILE__)
require File.expand_path('../files.rb', __FILE__)

Gem::Specification.new do |s|
  s.specification_version     = 1 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version
  s.required_ruby_version     = '>= 2.2.2'

  s.name                      = 'databasedestroyer'
  s.version                   = DatabaseDestroyerPackage::Version::STRING
  s.date                      = '2015-06-01'
  s.summary                   = 'DatabaseDestroyer, destroyer of [test] databases'
  s.authors                   = ['Dana Scheider']

  s.files                     = DatabaseDestroyerPackage::Files::FILES
  s.require_paths             = ['bin', 'config','lib']

  s.executables               = ['databasedestroyer']
  s.default_executable        = 'databasedestroyer'

  s.add_runtime_dependency     'mysql2', '~> 0.3', '>= 0.3.16'
  s.add_runtime_dependency     'rack-cors', '~> 0.4'
  s.add_runtime_dependency     'sequel', '~> 4.23'
  s.add_runtime_dependency     'sinatra', '~> 1.4.6'
  s.add_runtime_dependency     'thin', '~> 1.6.3'

  s.add_development_dependency 'bundler', '~> 1.7'

  s.has_rdoc         = true
  s.homepage         = 'https://github.com/danascheider/databasedestroyer'
  s.rdoc_options     = %w(--line-numbers --inline-source --title DatabaseDestroyer)
  s.rubygems_version = '1.1.1'
end
