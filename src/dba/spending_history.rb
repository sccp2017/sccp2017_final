require 'sequel'

class SpendingHistoryAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :spending_history do
            primary_key :id
            Datetime :spend_at
            Integer :type_id
            String :detail
            Integer :payment
            Integer :market_id
            
        end
        @history = db[:spending_history]
    end

    # 支出テーブルに追加する
    def spend() # e.g, {:spend_at => 日付クラス}
        # ここに記述
    end
    
    # 全支出履歴の取得
    def history_all
        # ここに記述
        []
    end

    # 日付を指定して支出履歴の取得
    def get_historys_by_date()
        # ここに記述
        []
    end

    # 必要なメソッドがあれば以下に追加
end
