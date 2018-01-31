require 'sinatra'
require 'sinatra/json'
require 'json'

require_relative 'dba/type.rb'

class MainApp < Sinatra::Base
    # タイプ情報を追加するエンドポイント
    # このエンドポイントのjsonのparameterは、
    #   {
    #        "name" : String,
    #   }
    post '/types', provides: :json do
        # HTTPリクエストのJSONのparameterをRubyで扱えるようにパースする
        # :keyがキーになる (e.g, params[:name])
        params = JSON.parse(request.body.read, {:symbolize_names => true})

        @type_access.add_type(params)
        status 200 # 成功
    end

    # タイプ情報を取得するエンドポイント
    get '/types' do
        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        json (@type_access.type_all)
    end

    # タイプ情報をidから取得するエンドポイント
    get '/types/:id' do
        # URIからパラメータを取りたい場合は params 変数を使う
        id = params[:id]

        # getメソッドはクライアントが情報の塊であるjsonを取得したいので、`json (XXXX)` で返す
        data = @type_access.get_type_by_id(id)

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
