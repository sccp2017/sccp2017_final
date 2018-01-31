require 'sequel'

class MarketAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :market do
            primary_key :id
            String :name
        end
        @market = db[:market]
    end

    # 店情報を追加
    def add_market(params)
        @market.insert(params)
    end
    
    # 全店一覧取得
    def market_all
        @market.all
    end

    # idから店の情報取得
    def get_market_by_id()
        # ここに記述
        {}
    end

    # 必要なメソッドがあれば以下に追加
end
