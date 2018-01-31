require 'sequel'

class TypeAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :type do
            primary_key :id
            String :name
        end
        @type = db[:type]
    end

    # 買ったもののタイプを追加する
    def add_type(params)
        @type.insert(params)
    end
    
    # タイプ一覧
    def type_all
        @type.all
    end
    
    # idからタイプ取得
    def get_type_by_id(id)
        @type.where(id: id).first
    end
end
