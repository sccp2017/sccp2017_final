# sccp2017_final

## How2use
```
$ rake init
$ rake start 
```

access `localhost:8080`

## curl command
確認に使います。
```
# GETするだけ
$ curl http://localhost:8080/path/to

# クエリパラメータを指定してGETする
$ curl -X GET http://localhost:8080/path/to -d '{"json_key":"json_value"}'

# POSTする
$ curl -X POST http://localhost:8080/path/to -d '{"json_key":"json_value"}'
```

## Questions
### POSTとGETの実装
- marketに既に実装されている `/markets` エンドポイントを `type` にも実装する
  - 同じエンドポイント、同じデータベースアクセッサ(ORMで)実装

### src/dba/history.rb にあるメソッド実装
1. `spend` は、データベースに引数として持っている `params` をInsertする
  - !注意 : SQLite3には日付型がないので、Integerで [UNIX時間](http://ruby-doc.org/core-2.1.5/Time.html#method-i-to_i) を `spend_at` として保持すると良い
2. `history_all` は、データベースに有るすべての履歴を取得
3. `get_history_by_date` は、データベースに有る履歴を、特定の日付だけ取得

historyを取得する系のものは、DBの `spending_history`テーブルから引き抜いて返す場合、 `type_id`, `market_id` などとなり、クライアントに不親切なので、 `type`, `market`テーブルからデータを抜き、それを返す

```
これは駄目
{
    "detail": "pay money", 
    "id": 1, 
    "market_id": 2,
    "payment": null,
    "spend_at": 1517497200, 
    "type_id": 1, 
}, 

以下のようなものが理想 (nameだけでも良い)
{
    "detail": "pay money", 
    "id": 1, 
    "market": {
        "id": 2, 
        "name": "aaaa"
    }, 
    "payment": null, 
    "spend_at": 1517497200, 
    "type": {
        "id": 1, 
        "name": "aaaa"
    }
}, 
```

### historyに触るAPIのエンドポイント実装
- `src/app.rb` に、前の問題で実装したデータベースアクセッサをAPIエンドポイントに紐付ける
- それぞれ、以下のエンドポイントを作る

| dba | API endpoint |
|:---:|:------------:|
|spend|POST /history|
|history_all|GET /history/all|
|get_history_by_date|GET /history|

### 余力ある人向けの実装
1. `type_id` でhistoryを取得するエンドポイント
2. `market_id` でhistoryを取得するエンドポイント
3. 期間を指定して支払い履歴を取得するエンドポイント
