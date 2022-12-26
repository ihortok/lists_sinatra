class App < Sinatra::Base
  set :method_override, true

  get '/' do
    @lists = database[:lists]

    erb :'lists/index.html'
  end

  get '/lists/:id' do
    @list = database[:lists].where(id: params[:id]).first

    erb :'lists/show.html'
  end

  get '/lists/:id/edit' do
    @list = database[:lists].where(id: params[:id]).first

    erb :'lists/edit.html'
  end

  post '/lists' do
    database[:lists].insert(params[:list])

    redirect '/'
  end

  patch '/lists' do
    list = database[:lists].filter(id: params[:id])
    list.update(params[:list])

    redirect "/lists/#{list.first[:id]}"
  end

  delete '/lists' do
    database[:lists].filter(id: params[:id]).delete

    redirect '/'
  end

  private

  def database
    @database ||= Sequel.connect('sqlite://db/lists_database.db')
  end
end
