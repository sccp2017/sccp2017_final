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

## Questions
