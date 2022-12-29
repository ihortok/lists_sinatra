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
    database[:lists].insert(params[:list].merge({ item_attributes: }))

    redirect '/'
  end

  patch '/lists' do
    list = database[:lists].where(id: params[:id])
    list.update(params[:list].merge({ item_attributes: }))

    redirect "/lists/#{list.first[:id]}"
  end

  delete '/lists' do
    database[:items].where(list_id: params[:id]).delete
    database[:lists].where(id: params[:id]).delete

    redirect '/'
  end

  post '/lists/:id/items' do
    database[:items].insert(params[:item]
                    .merge({ list_id: params[:id], attributes: params[:attributes]&.to_json }))

    redirect "/lists/#{params[:id]}"
  end

  delete '/lists/:id/items' do
    database[:items].where(id: params[:item_id]).delete

    redirect "/lists/#{params[:id]}"
  end

  private

  def database
    @database ||= Sequel.connect('sqlite://db/lists_database.db')
  end

  def item_attributes
    item_attributes = params[:item_attributes]&.select { |_k, v| v[:name].strip != '' } || {}
    item_attributes.empty? ? nil : item_attributes.to_json
  end
end
