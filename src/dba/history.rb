require 'sequel'
require 'time'

require_relative 'market.rb'
require_relative 'category.rb'

class SpendingHistoryAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :spending_history do
            primary_key :id
            String  :commodityName
            Integer :amount
            Integer :categoryId
            Integer :marketId
            Integer :month
            Integer :day
        end

        @history = db[:spending_history]
        @category_access = CategoryAccess.new
        @market_access = MarketAccess.new
    end

    # 支出テーブルに追加する
    def spend(history)
        # :spend_month, :spend_dayが空なら今の時間を入れる
        if !history.has_key?(:month) || history[:month] == nil
                || !history.has_key?(:month) || history[:day] == nil then
            history[:month] = Time.now.month
            history[:day] = Time.now.day
        end

        @history.insert(history)
    end
    
    # 全支出履歴の取得
    def history_all
        @history.all.map {|history| 
            convert_to_response_from_model(history)
        }
    end

    # 日付を指定して支出履歴の取得
    def get_historys_by_date(month, day)
        @history.where(:month => month, :day => day).all.map {|history| 
            convert_to_response_from_model(history)
        }
    end

    # 指定のcategory_idの支出
    def get_historys_by_category(category)
        history = @history.where(category_id: category).first
        history == nil ? {} : convert_to_response_from_model(history)
    end
    
    # 指定のmarket_idの支出
    def get_historys_by_market(market)
        history = @history.where(market_id: market).first
        history == nil ? {} : convert_to_response_from_model(history)
    end

    # 指定の期間の支出履歴の取得 (TODO: )
    def get_history_by_period(first_day, last_day)
        @history.where(:spend_at => first_day..last_day).all.map {|history| 
            convert_to_response_from_model(history)
        }
    end

    def convert_to_response_from_model(data)
        # DBから抜いてきた状態のままでは、category_id, market_id など、わかりづらいため、
        # category_id, market_id を それぞれのDBから持ってきたHashに変換し、キーを変更する

        # :category をキーとしてcategoryの情報を入れる
        data[:category] = @category_access.get_category_by_id(data[:category_id])
        # 上の :category にidは含まれているので、元のcategory_idを削除する
        data.delete(:category_id)
        # :market をキーとしてmarketの情報を入れる
        data[:market] = @category_access.get_category_by_id(data[:market_id])
        # 上の :market にidは含まれているので、元のmarket_idを削除する
        data.delete(:market_id)
        data
    end
end
