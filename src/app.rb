require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'

require_relative 'dba/category.rb'
require_relative 'dba/market.rb'
require_relative 'dba/history.rb'

class MainApp < Sinatra::Base
    configure :development do
        register Sinatra::Reloader
    end

    # これより上は気にしなくていい

    def initialize
        # スーパークラスのコンストラクタ呼び出し
        super()

        # DBへアクセスするためのクラスを初期化し、フィールドに格納
        @category_access = CategoryAccess.new
        @market_access = MarketAccess.new
        @spending_access = SpendingHistoryAccess.new
    end

    # curl http://localhost:8080
    get '/' do
        json 1234
    end

    # curl http://localhost:8080/12
    get '/:id' do
        json({id: params[:id]})
    end

    # curl -X POST http://localhost:8080/echo -d '{"key":"value"}'
    post '/echo' do
        params = JSON.parse(request.body.read, {:symbolize_names => true})

        json (params)
    end

    # 店情報を追加するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "name" : String,
    #   }
    post '/markets', provides: :json do
        # HTTPリクエストのJSONのparameterをRubyで扱えるようにパースする
        # :keyがキーになる (e.g, params[:name])
        params = JSON.parse(request.body.read, {:symbolize_names => true})

        @market_access.add_market(params)
        status 200 # 成功
    end

    # 店情報を取得するエンドポイント
    get '/markets' do
        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        json (@market_access.market_all)
    end

    # カテゴリを追加するエンドポイント
    post '/categories', provides: :json do
    end

    # カテゴリ情報を取得するエンドポイント
    get '/categories' do
    end

    # 支払履歴に追加するエンドポイント
    post '/history', provides: :json do
    end

    # すべての支払履歴を取得する
    get '/history/all' do
    end

    # 特定の日付の支払履歴のみを抽出する
    get '/history/date' do
    end

    # 今までの支出総額
    get 'history/sum' do
    end
end
