require 'ya2yaml'
require 'will_paginate'

module Tolk
end

Mime::Type.register_alias "text/yaml", :yml

engine = Rails::Plugin.new File.expand_path('../..', __FILE__)
engine.instance_variable_set('@name', 'tolk')

# turbohax
ObjectSpace.each_object(Rails::Plugin::Loader) do |loader|
  loader.engines << engine
end

# enable autoloading
ActiveSupport::Dependencies.load_paths.concat engine.load_paths

Rails.configuration.middleware.use 'Rack::Static',
  :urls => ['/tolk/reset.css', '/tolk/screen.css'],
  :root => File.join(engine.directory, 'public')

# ultrahax
if 'script/generate' == $0 and defined?(Bundler)
  require 'rails_generator'
  source = Rails::Generator::PathSource.new(:tolk, File.join(engine.directory, 'generators'))
  Rails::Generator::Base.sources << source
end
