WYSYWIKI - WYSIWYGなWiki

#基本の構成
* node.js
* socket.io
* redisで記事管理


#機能
* socket.emitしてリアルタイムに更新しあう(Google-docsライクにしよう)

#メモ&提案とか
* fresherEditorで文字列をリッチに編集できるのでそれ使う
http://jquer.in/jquery-plugins-for-html5-forms/freshereditor/
* Foundation UIとかいうのが最近はBootstrapより受けてるのでそれで

#アイデア
* 画面に小さいフレームでチャットがあると良さそう
** (データ永続化しないで、その場の人しか見えないつぶやき&議論)
* データを「取ってくる&送る、見る」だけじゃなくて、「コマンドを実行」したり出来ると良い
** 特定のURLに対してPOSTするボタンとかが置けたら、ドア開けページとか作れるわけで