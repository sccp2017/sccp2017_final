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
        status 201 # Created
    end

    # 店情報を取得するエンドポイント
    get '/markets' do
        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        json (@market_access.market_all)
    end

    # 店情報をidから取得するエンドポイント
    get '/markets/:id' do
        # URIからパラメータを取りたい場合は params 変数を使う
        id = params[:id]

        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        data = @market_access.get_market_by_id(id)

        # データがない場合404を返す
        if data == nil then
            status 404
        else
            # dataがnilでなければJSONで返す
            json (data)
        end
    end

    # カテゴリ情報を追加するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "name" : String,
    #   }
    post '/categories', provides: :json do
        # HTTPリクエストのJSONのparameterをRubyで扱えるようにパースする
        # :keyがキーになる (e.g, params[:name])
        params = JSON.parse(request.body.read, {:symbolize_names => true})

        @category_access.add_category(params)
        status 201 # Created
    end

    # カテゴリ情報を取得するエンドポイント
    get '/categories' do
        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        json (@category_access.category_all)
    end

    # カテゴリ情報をidから取得するエンドポイント
    get '/categories/:id' do
        # URIからパラメータを取りたい場合は params 変数を使う
        id = params[:id]

        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        data = @category_access.get_category_by_id(id)

        # データがない場合、404を返す
        if data == nil then
            status 404
        else
            json (data)
        end
    end
    
    # 支払い情報を追加するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "category_id"   : Integer,
    #        "market_id" : Integer,
    #        "detail"    : String,
    #        "payment"   : Integer,
    #        "spend_at"  : String       // e.g, `2017-01-31` (optional)
    #   }
    post '/history', provides: :json do
        # HTTPリクエストのJSONのparameterをRubyで扱えるようにパースする
        # :keyがキーになる (e.g, params[:name])
        params = JSON.parse(request.body.read, {:symbolize_names => true})

        @spending_access.spend(params)
        status 201 # Created
    end

    # 全支払い情報を取得するエンドポイント
    get '/history/all' do
        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        json (@spending_access.history_all)
    end

    # market_id で取得するエンドポイント
    get '/history/markets/:id' do
        id = params[:id]
        json (@spending_access.get_historys_by_market(id))
    end

    # category_id で取得するエンドポイント
    get '/history/categories/:id' do
        id = params[:id]
        json (@spending_access.get_historys_by_category(id))
    end
    
    # 支払い情報を日付から取得するエンドポイント
    #   {
    #        "date"   : String       // e.g, `2017-01-31`
    #   }
    get '/history/date' do
        params = JSON.parse(request.body.read, {:symbolize_names => true})
        date = params[:date]

        json (@spending_access.get_historys_by_date(date))
    end

    # 支払い情報を期間から取得するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "first"  : String       // e.g, `2017-01-31`
    #        "last"   : String       // e.g, `2017-01-31`
    #   }
    get '/history/period' do
        # HTTPリクエストのJSONのparameterをRubyで扱えるようにパースする
        # :keyがキーになる (e.g, params[:first])
        params = JSON.parse(request.body.read, {:symbolize_names => true})

        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        data = @spending_access.get_history_by_period(params[:first], params[:last])

        # データがnilの場合、クライアント由来のエラーなので4XXを返す(この場合404)
        if data == nil then
            status 404
        else
            json (data)
        end
    end
end
