require 'sinatra'
require 'sinatra/json'
require 'json'

require_relative 'dba/history.rb'

class HistoryRoute < Sinatra::Base
    # DBへアクセスするためのクラスを初期化し、フィールドに格納
    @spending_access = SpendingHistoryAccess.new

    # 支払い情報を追加するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "category_id"   : Integer,
    #        "market_id" : Integer,
    #        "detail"    : String,
    #        "payment"   : Integer,
    #        "spend_at"  : String       // e.g, `2017-01-31` (optional)
    #   }
    post '/payments', provides: :json do
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
            status 200
            json (data)
        end
    end
end
