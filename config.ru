# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'bcrypt'

db_username = ENV['LISTS_DATABASE_USERNAME']
db_password = ENV['LISTS_DATABASE_PASSWORD']
db_host = ENV['LISTS_DATABASE_HOST']
db_name = ENV['LISTS_DATABASE_NAME']

DB = Sequel.connect("postgresql://#{db_username}:#{db_password}@#{db_host}/#{db_name}")

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
