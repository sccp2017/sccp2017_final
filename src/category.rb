require 'sinatra'
require 'sinatra/json'
require 'json'

require_relative 'dba/category.rb'

class CategoryRoute < Sinatra::Base
    # DBへアクセスするためのクラスを初期化し、フィールドに格納
    @category_access = CategoryAccess.new

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
            status 200
            json (data)
        end
    end
end
