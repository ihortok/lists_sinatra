class App < Sinatra::Base
  set :method_override, true

  get '/' do
    @lists = database[:lists]

    erb :'lists/index.html', layout: :'layouts/application.html'
  end

  get '/lists/:id' do
    @list = database[:lists].where(id: params[:id]).first
    @items = database[:items].where(list_id: params[:id]).all

    erb :'lists/show.html', layout: :'layouts/application.html'
  end

  get '/lists/:id/edit' do
    @list = database[:lists].where(id: params[:id]).first

    erb :'lists/edit.html', layout: :'layouts/application.html'
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

  post '/lists/:id/items' do
    database[:items].insert(params[:item].merge({ list_id: params[:id] }))

    redirect "/lists/#{params[:id]}"
  end

  delete '/lists/:id/items' do
    database[:items].filter(id: params[:item_id]).delete

    redirect "/lists/#{params[:id]}"
  end

  private

  def database
    @database ||= Sequel.connect('sqlite://db/lists_database.db')
  end
end
