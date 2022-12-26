class App < Sinatra::Base
  get '/' do
    @lists = database[:lists]

    erb :'dashboard/index.html'
  end

  private

  def database
    @database ||= Sequel.connect('sqlite://db/lists_database.db')
  end
end
