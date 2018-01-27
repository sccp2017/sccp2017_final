require 'sequel'

class UserAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :user do
            primary_key :id
            String :name
        end
        @user = db[:user]
    end

    def add_user(user)
        @user.insert(user)
    end
    
    def user_all
        @user.all
    end
end

# 上の様に、コンストラクタ内でテーブルの定義、それにアクセスするためにORMを利用したメソッドを定義
