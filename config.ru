require 'rack/unreloader'
require 'sinatra'
require 'sequel'

Unreloader = Rack::Unreloader.new(handle_reload_errors: true){App}
Unreloader.require './app.rb'

run Unreloader
