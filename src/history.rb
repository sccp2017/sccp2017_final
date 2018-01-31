require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'

require_relative 'dba/type.rb'
require_relative 'dba/market.rb'
require_relative 'dba/spending_history.rb'

class MainApp < Sinatra::Base
    # 支払い情報を追加するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "type_id"   : Integer,
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
        status 200 # 成功
    end

    # 全支払い情報を取得するエンドポイント
    get '/history/all' do
        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        json (@spending_access.history_all)
    end

    # 店情報を日付から取得するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "first"  : String       // e.g, `2017-01-31`
    #        "last"   : String       // e.g, `2017-01-31`
    #   }
    get '/history' do
        # HTTPリクエストのJSONのparameterをRubyで扱えるようにパースする
        # :keyがキーになる (e.g, params[:name])
        params = JSON.parse(request.body.read, {:symbolize_names => true})


        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        p params
        data = @spending_access.get_history_by_period(params[:first], params[:last])

        # データがnilの場合、クライアント由来のエラーなので4XXを返す(この場合400)
        if data == nil then
            status 400
            json ({})
            return
        end

        # ここまで到達すれば、data != nil なのでstatus 200 と、dataをjsonにして返す
        status 200
        json (data)
    end
end
