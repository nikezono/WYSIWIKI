#WYSYWIKI - WYSIWYGなWiki

##なにこれ
[Gyazz](http://github.com/masui/gyazz)を意識したWebsocketによるwiki
イージーな操作と動作の軽快さを目指す

##サンプル
heroku:[http://wysiwiki.herokuapp.com](http://wysiwiki.herokuapp.com)

##基本の構成
###サーバサイド
* node.js
* socket.io
* redisで記事管理
* テンプレートエンジンはjade
* [express-coffee](http://github.com/twilson63/express-coffee) をcloneしているので全部coffeeで書く

###ビュー
* [fresherEditor](http://jquer.in/jquery-plugins-for-html5-forms/freshereditor/)で文字列をリッチに編集できるのでそれ使う
* Foundation UIとかいうのが最近はBootstrapより受けてるのでそれで

##ルーティング(基本的に[Gyazz](http://github.com/masui/gyazz)を踏襲)
    /  - index.jade
    /:name - 一覧ページ
    /:name/:article - 記事ページ


##機能
* socket.emitしてリアルタイムに更新しあう(Google-docsライクにしよう)

##アイデア
* 画面に小さいフレームでチャットがあると良さそう
** (データ永続化しないで、その場の人しか見えないつぶやき&議論)
* データを「取ってくる&送る、見る」だけじゃなくて、「コマンドを実行」したり出来ると良い
** 特定のURLに対してPOSTするボタンとかが置けたら、ドア開けページとか作れるわけで


##メモ&提案とか
