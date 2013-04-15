
module.exports = (io,db) ->

	# socket.io
	io.sockets.on "connection", (socket) ->
	  console.log 'connected'

	  #initialize
	  socket.on 'init', (req) ->

	    v = init_socket(socket,req)

	    ## ユーザが増えたことを通知
	    #roomに入れて管理する
	    socket.join v.wiki
	    socket.join v.article unless v.article is null
	    #roomに接続数を通知
	    io.sockets.to(v.wiki).emit 'connect wiki', io.sockets.clients(v.wiki).length
	    io.sockets.to(v.article).emit 'connect article', io.sockets.clients(v.article).length

	  ##ユーザが減ったことを通知
	  socket.on "disconnect",(req) ->
	    console.log "disconnected"

	    v = init_socket(socket,req)

	    #roomから出る
	    socket.leave v.wiki
	    socket.leave v.article unless v.article is null

	    #roomに接続数を通知
	    io.sockets.to(v.wiki).emit 'disconnect wiki',io.sockets.clients(v.wiki).length-1
	    io.sockets.to(v.article).emit 'disconnect article', io.sockets.clients(v.article).length-1


	  #他の画面で編集が行われたら
	  #[自分以外同じルームのユーザ]にemit出来ない
	  #一回出る
	  socket.on "msg send", (res) ->
	    console.log "msg send"
	    socket.leave res.article
	    socket.broadcast.to(res.article).emit 'msg push',res.msg
	    socket.join res.article

	  #Save DB
	  # wikiのハッシュの中にArray作ってpushしてる
	  socket.on "db send", (res) ->
	    date = new Date().getTime().toFixed()
	    db.zadd res.article,new Date().getTime().toFixed(),res.msg, (err,res) ->
	      console.log "res.article:"+res.article

	init_socket = (socket,req) ->
	  v = {}
	  v.wiki = req.wiki
	  v.article = req.wiki + ":" + req.article unless req.article is null
	  return v
