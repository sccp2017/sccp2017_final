require 'sinatra'
require 'sinatra/json'
require 'json'

require_relative 'dba/category.rb'

class MainApp < Sinatra::Base
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
        status 200 # 成功
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
