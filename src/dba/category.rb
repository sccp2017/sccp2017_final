require 'sequel'

class CategoryAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :category do
            primary_key :id
            String :name
        end
        @category = db[:category]
    end

    # 買ったもののタイプを追加する
    def add_category(params)
        @category.insert(params)
    end
    
    # タイプ一覧
    def category_all
        @category.all
    end
    
    # idからタイプ取得
    def get_category_by_id(id)
        @category.where(id: id).first
    end
end
