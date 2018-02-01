require 'sinatra'
require 'sinatra/reloader'

require_relative 'category.rb'
require_relative 'market.rb'
require_relative 'history.rb'

require_relative 'dba/category.rb'
require_relative 'dba/market.rb'
require_relative 'dba/history.rb'

class MainApp < Sinatra::Base
    configure :development do
        register Sinatra::Reloader
    end

    def initialize
        # スーパークラスのコンストラクタ呼び出し
        super()

        # DBへアクセスするためのクラスを初期化し、フィールドに格納
        @category_access = CategoryAccess.new
        @market_access = MarketAccess.new
        @spending_access = SpendingHistoryAccess.new
    end

    get '/' do
        'Hello, world'
    end

    get '/ping' do
        'pong'
    end

    post '/echo' do
        params = JSON.parse(request.body.read, {:symbolize_names => true})

        json (params)
    end

    

end
