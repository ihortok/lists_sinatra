require 'sinatra'

get '/' do
  erb :'dashboard/index.html'
end
