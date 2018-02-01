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

## 家計簿の実装

まず、家計簿というのは買い物の記録を意味します。
ここでは主に、買い物をした際の商品、値段、店舗、日付を記録していきます。
家計簿を実装する上で、以下の3つのスキーマを作成します。

#### 1. カテゴリスキーマ

商品だけ並べられても、どれがどういう系統の商品なのかを一目で把握するのは大変です。
こういった問題を解決するために、あらかじめカテゴリ(=系統)をこのスキーマで設定します。

```
カテゴリ (id, カテゴリ名)

例:
 category (0, "食費")
 category (1, "娯楽")
 category (2, "日用品")
```

#### 2. 店舗スキーマ

スーパーマーケットやコンビニなど、買い物をした場所はある程度限られてきます。
そういった場所をあらかじめこのスキーマで設定しておきます。

```
店舗 (id, 店舗名)

例:
 market (0, "ヨークベニマル")
 market (1, "ローソン")
 market (2, "ツタヤ")
```

#### 3. 支出履歴スキーマ

最後に要となる支出履歴を設定していきます。
実際に家計簿に記録を行う工程にあたります。
ここでは、冒頭で説明した項目(商品、値段、店舗、日付)を設定します。

```
支出履歴 (id, 日付, カテゴリid, 商品, 金額, 店舗id)
注意 - 日付は計算上文字列では面倒なので、整数型で 月日 とします (例: 1月1日 => 101, 12月31日 => 1231)

例:
 history (0, 201, 0, "チョコレート", 120, 1)
 history (1, 131, 2, "洗剤", 450, 0)
 history (2, 130, 1, "DVD", 1500, 2)
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

## オプション問題
1. `spending_history` テーブルからデータを月、日を元に取得できる処理を完成させろ
  - `src/dba/history.rb` にある `get_history_by_date` を使う
  - `src/app.rb` にある `get '/history/:month/:day'` を使う
2. `spending_history` テーブルから今までの支出総額を取得する処理を追加せよ

