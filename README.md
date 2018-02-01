# sccp2017_final

## How2use
```
$ rake init
$ rake start 
```

access `localhost:8080`

## 確認の例
```
# マーケットにデータを挿入
$ curl -X POST https://localhost:8080/markets -d {"name":"711"}

# マーケット一覧取得
$ curl http://localhost:8080/markets
{"id":1, "name":"711"}
```

## Questions
なお、解答は `answer` ブランチにあります。わからなかったらそちらを参考にしてください  
ただ、これが完全に良い実装ではないので、参考にする程度までに留めておいてください  
