# sccp2017_final

## How2use
```
$ rake init
$ rake start 
```

# Sinatra実装の確認
```
# 店舗情報(market)を取得
#  最初は空
$ curl http://localhost:8080/markets
[]

# 店舗情報を追加
$ curl -X POST https://localhost:8080/markets -d {"name":"711"}

# もう一度、店舗情報を確認
$ curl http://localhost:8080/markets
[{"id":1, "name":"711"}]
```

## システム構成
![](./img/household.png)

## Questions
1. `src/dba/market.rb` を参考に `src/dba/category.rb` を完成させよ

2. `src/app.rb` にすでに実装されている店舗情報(`market`)に関する処理を参考にして購入した商品(`category`)に関する以下の処理を追加せよ
  - `category` テーブルに購入した商品( `category` )を登録する処理
  - `category` テーブルから全てのデータを取得する処理
  - `category` テーブルから `category` のidを元に購入した商品を取得する処理

3. `src/dba/history.rb` を以下の仕様にそって完成させよ
  - 買い物での支出をとしてデータベースの `spending_history` テーブルに追加する `spend` メソッド
  - `spending_history` テーブルの全てのデータの取得を行う `history_all` メソッド

4. `src/app.rb` に支出履歴に関する以下の処理を追加せよ
  - `spending_history` テーブルに支出履歴( `history` )をデータベース登録する処理
  - `spending_history` テーブルから全支出履歴の取得を行う処理

