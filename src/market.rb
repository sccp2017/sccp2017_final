require 'sinatra'
require 'sinatra/json'
require 'json'

require_relative 'dba/market.rb'

class MarketRoute < Sinatra::Base
    # DBへアクセスするためのクラスを初期化し、フィールドに格納
    @market_access = MarketAccess.new

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
            status 200
            json (data)
        end
    end
end
