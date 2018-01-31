require 'sinatra'
require 'sinatra/json'
require 'json'

require_relative 'dba/market.rb'

class MainApp < Sinatra::Base
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

    # 店情報をidから取得するエンドポイント
    get '/markets/:id' do
        # URIからパラメータを取りたい場合は params 変数を使う
        id = params[:id]

        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        data = @market_access.get_market_by_id(id)

        # データがない場合、クライアント由来のエラーなので4XXを返す(この場合400)
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
