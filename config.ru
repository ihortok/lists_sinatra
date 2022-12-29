# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'bcrypt'

if ENV['RACK_ENV'] == 'development'
  require 'pry'
  require 'rack/unreloader'

  Unreloader = Rack::Unreloader.new(handle_reload_errors: true) { App }
  Unreloader.require './app.rb'

  run Unreloader
else
  require './app'

  run App
end
