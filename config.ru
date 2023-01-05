# frozen_string_literal: true

require 'sinatra'
require 'sequel'
require 'bcrypt'

DB = if ENV['RACK_ENV'] == 'development'
       Sequel.connect('sqlite://db/lists_database.db')
     else
       Sequel.connect("postgresql://#{ENV['LISTS_DATABASE_USERNAME']}:#{ENV['LISTS_DATABASE_PASSWORD']}@#{ENV['LISTS_DATABASE_HOST']}/#{ENV['LISTS_DATABASE_NAME']}")
     end

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
