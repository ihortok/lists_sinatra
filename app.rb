class App < Sinatra::Base
  get '/' do
    erb :'dashboard/index.html'
  end
end
