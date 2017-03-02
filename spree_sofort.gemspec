# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sofort'
  s.version     = '3.2'
  s.summary     = 'Add sofortueberweisung payment to spree'
  s.description = ''
  s.required_ruby_version = '>= 1.9.3'

  s.author            = 'Stefan Hartmann'
  s.email             = 'stefan@yo-code.de'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '> 3.1'
  s.add_dependency 'httparty'
  s.add_dependency 'actionpack-xml_parser'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'sass-rails'
end
