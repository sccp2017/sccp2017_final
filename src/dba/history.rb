require 'sequel'
require 'time'

require_relative 'market.rb'
require_relative 'category.rb'

class SpendingHistoryAccess
    def initialize(db = Sequel.sqlite("./db/database.db"))
        db.create_table? :spending_history do
            primary_key :id
            Integer :spend_at # UNIX time
            Integer :category_id
            String :detail
            Integer :payment
            Integer :market_id
            
        end
        @history = db[:spending_history]
        @category_access = CategoryAccess.new
        @market_access = MarketAccess.new
    end

    # 支出テーブルに追加する
    def spend(params)
        # :spend_atが空なら今の時間を入れる
        if !params.has_key?(:spend_at) || params[:spend_at] == nil then
            params[:spend_at] = Time.now.to_i
        else
            params[:spend_at] = Time.parse(params[:spend_at]).to_i
        end

        @history.insert(params)
    end
    
    # 全支出履歴の取得
    def history_all
        @history.all.map {|history| 
            convert(history)
        }
    end

    # 日付を指定して支出履歴の取得
    def get_historys_by_date(day)
        @history.where(spend_at: Time.parse(day).to_i..(Time.parse(day).to_i+24*60*60)).all.map {|history| 
            convert(history)
        }
    end

    # 指定のcategory_idの支出
    def get_historys_by_category(category)
        history = @history.where(category_id: category).first
        history == nil ? {} : convert(history)
    end
    
    # 指定のmarket_idの支出
    def get_historys_by_market(market)
        history = @history.where(market_id: market).first
        history == nil ? {} : convert(history)
    end

    # 指定の期間の支出履歴の取得
    def get_history_by_period(first_day, last_day)
        @history.where(:spend_at => Time.parse(first_day).to_i..Time.parse(last_day).to_i).all.map {|history| 
            convert(history)
        }
    end

    def convert_to_response_from_model(data)
        # DBから抜いてきた状態のままでは、category_id, market_id など、わかりづらいため、
        # category_id, market_id を それぞれのDBから持ってきたHashに変換する

        # :category をキーとしてcategoryの情報を入れる
        data[:category] = @category_access.get_category_by_id(data[:category_id])
        # :category にidは含まれているので、元のcategory_idを削除する
        data.delete(:category_id)
        # :market をキーとしてmarketの情報を入れる
        data[:market] = @category_access.get_category_by_id(data[:market_id])
        # :market にidは含まれているので、元のmarket_idを削除する
        data.delete(:market_id)
        data
    end
end
