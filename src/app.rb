require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'
require_relative 'dba.rb'

class MainApp < Sinatra::Base
    configure :development do
        register Sinatra::Reloader
    end

    # これより上は気にしなくていい

    def initialize
        super()
        # DBへアクセスするためのクラスを初期化し、フィールドに格納
        @useraccess = UserAccess.new
    end

    get '/' do
        'Hello, world'
    end

    get '/ping' do
        'pong'
    end

    post '/users', provides: :json do
        params = JSON.parse(request.body.read, {:symbolize_name => true})
        @useraccess.add_user(params)
        status 200
    end

    get '/users' do
        json (@useraccess.user_all)
    end
end
