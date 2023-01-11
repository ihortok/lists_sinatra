# frozen_string_literal: true

class App < Sinatra::Base
  set :method_override, true
  set :views, 'app/views'
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

  before '/*' do
    if user_signed_in?
      return unless sign_in_or_sign_up_path?

      redirect '/'
    else
      return if sign_in_or_sign_up_path?

      redirect '/users/sign_in'
    end
  end

  # users
  get '/users/sign_up' do
    erb :'users/sign_up.html', layout: :'layouts/application.html'
  end

  post '/users/sign_up' do
    redirect '/users/sign_up' unless email_valid? && password_valid?

    password_digest = BCrypt::Password.create(params[:password])
    DB[:users].insert({ email: params[:email], password_digest: })
    session[:user_id] = DB[:users].where(email: params[:email]).first[:id]

    redirect '/'
  end

  get '/users/sign_in' do
    erb :'users/sign_in.html', layout: :'layouts/application.html'
  end

  post '/users/sign_in' do
    user = DB[:users].where(email: params[:email])

    redirect '/users/sign_in' unless user.first
    redirect '/users/sign_in' unless BCrypt::Password.new(user.first[:password_digest]) == params[:password]

    session[:user_id] = user.first[:id]

    redirect '/'
  end

  delete '/users/sign_out' do
    redirect '/' unless user_signed_in?

    session.clear

    redirect '/'
  end

  # root
  get '/' do
    @lists = DB[:lists].where(user_id: current_user[:id])

    erb :'lists/index.html', layout: :'layouts/application.html'
  end

  # lists
  get '/lists/:id' do
    @list = DB[:lists].where(id: params[:id], user_id: current_user[:id]).first
    @items = DB[:items].where(list_id: @list[:id]).all

    erb :'lists/show.html', layout: :'layouts/application.html'
  end

  get '/lists/:id/edit' do
    @list = DB[:lists].where(id: params[:id], user_id: current_user[:id]).first

    erb :'lists/edit.html', layout: :'layouts/application.html'
  end

  post '/lists' do
    DB[:lists].insert(params[:list].merge({ user_id: current_user[:id], item_attributes: }))

    redirect '/'
  end

  patch '/lists' do
    list = DB[:lists].where(id: params[:id], user_id: current_user[:id])
    list.update(params[:list].merge({ item_attributes: }))

    redirect "/lists/#{list.first[:id]}"
  end

  delete '/lists' do
    DB[:items].where(list_id: params[:id], user_id: current_user[:id]).delete
    DB[:lists].where(id: params[:id]).delete

    redirect '/'
  end

  # items
  get '/items/:id/edit' do
    @item = DB[:items].where(id: params[:id], user_id: current_user[:id]).first
    @list = DB[:lists].where(id: @item[:list_id]).first

    erb :'items/edit.html', layout: :'layouts/application.html'
  end

  post '/items' do
    DB[:items].insert(params[:item].merge({ user_id: current_user[:id], attributes: params[:attributes]&.to_json }))

    redirect "/lists/#{params[:item][:list_id]}"
  end

  patch '/items' do
    item = DB[:items].where(id: params[:id], user_id: current_user[:id])
    item.update(params[:item].merge({ attributes: params[:attributes]&.to_json }))

    redirect "/lists/#{item.first[:list_id]}"
  end

  delete '/items' do
    DB[:items].where(id: params[:id], user_id: current_user[:id]).delete

    redirect "/lists/#{params[:list_id]}"
  end

  helpers do
    def user_signed_in?
      !!current_user
    end

    def current_user
      DB[:users].where(id: session[:user_id]).first
    end

    def sign_in_path?
      request.path_info == '/users/sign_in'
    end

    def sign_up_path?
      request.path_info == '/users/sign_up'
    end

    def sign_in_or_sign_up_path?
      sign_in_path? || sign_up_path?
    end

    def list_item_attribute_input_types
      {
        String: 'text',
        Integer: 'number',
        Checkbox: 'checkbox',
        Datetime: 'datetime-local'
      }
    end
  end

  private

  def item_attributes
    item_attributes = params[:item_attributes]&.select { |_k, v| v[:name].strip != '' } || {}
    item_attributes.empty? ? nil : item_attributes.to_json
  end

  def email_valid?
    return false unless params[:email]
    return false if DB[:users].where(email: params[:email]).any?

    true
  end

  def password_valid?
    return false unless params[:password]
    return false if params[:password].length < 8
    return false if params[:password].length > 20

    true
  end
end
