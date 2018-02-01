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
        @history.all.map {|item| 
            convert(item)
        }
    end

    # 日付を指定して支出履歴の取得
    def get_historys_by_date(day)
        @history.where(spend_at: Time.parse(day).to_i..(Time.parse(day).to_i+24*60*60)).all.map {|item| 
            convert(item)
        }
    end

    # 指定のcategory_idの支出
    def get_historys_by_category(category)
        data = @history.where(category_id: category).first
        data == nil ? {} : convert(data)
    end
    
    # 指定のmarket_idの支出
    def get_historys_by_market(market)
        data = @history.where(market_id: market).first
        data == nil ? {} : convert(data)
    end

    # 指定の期間の支出履歴の取得
    def get_history_by_period(first_day, last_day)
        @history.where(:spend_at => Time.parse(first_day).to_i..Time.parse(last_day).to_i).all.map {|item| 
            convert(item)
        }
    end

    def convert(data)
        data[:category] = @category_access.get_category_by_id(data[:category_id])
        data.delete(:category_id)
        data[:market] = @category_access.get_category_by_id(data[:market_id])
        data.delete(:market_id)
        data
    end
end
