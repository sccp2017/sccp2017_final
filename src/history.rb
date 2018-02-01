require 'sinatra'
require 'sinatra/json'
require 'json'

require_relative 'dba/history.rb'

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

    # market_id で取得するエンドポイント
    get '/history/market/:id' do
        id = params[:id]
        json (@spending_access.get_historys_by_market(id))
    end

    # type_id で取得するエンドポイント
    get '/history/type/:id' do
        id = params[:id]
        json (@spending_access.get_historys_by_type(id))
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

        # なお、授業では堀り下げなかったがここでは例外処理を行っている
        # なぜならjson文字列をruby#hashにうまくパースできなかったときにどうするか記述する必要があるからである
        # begin内で失敗した場合、rescue以下が実行される
        #
        # 詳しくは https://docs.ruby-lang.org/ja/latest/doc/spec=2fcontrol.html#begin
        begin
            params = JSON.parse(request.body.read, {:symbolize_names => true})
        rescue JSON::ParserError => e
            status 400
            return
        end

        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        data = @spending_access.get_history_by_period(params[:first], params[:last])

        # データがnilの場合、クライアント由来のエラーなので4XXを返す(この場合400)
        if data == nil then
            status 400
            return
        end

        # ここまで到達すれば、data != nil なのでstatus 200 と、dataをjsonにして返す
        status 200
        json (data)
    end
end
