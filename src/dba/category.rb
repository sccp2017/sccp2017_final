require 'sequel'

class CategoryAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :category do
            primary_key :id
            String :name
        end
        @category = db[:category]
    end

    # 買ったもののカテゴリを追加する
    def add_category(category)
        # ここに記述
    end
    
    # カテゴリ一覧
    def category_all
        # ここに記述
        []
    end
    
    # idからカテゴリ取得
    def get_category_by_id(id)
        # ここに記述
        {}
    end

    # 必要なメソッドがあれば以下に追加
end
