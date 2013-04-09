$ ->

  # 同じwikiに居る人としか通信しない
  # Backbone.jsとかで書いたほうが綺麗?
  url = window.location.pathname.split "/"
  wiki =  url[1]
  article = url[2]

  # トップページ以外
  unless wiki is ''

    socket = io.connect 'http://localhost'
    socket.on "connect", ->
      console.log "connected"

      #同じwikiに居る人とのみ繋がる
      socket.json.emit 'init', {'wiki':wiki,'article':article}

      #新しいユーザが来たとき
      socket.on 'connect wiki', (num) ->
        $('#wiki-connection #wiki-number').text(num)
      socket.on 'connect article', (num) ->
        $('#article-connection #article-number').text(num)

      #ユーザが減った時
      socket.on 'disconnect wiki', (num) ->
        $('#wiki-connection #wiki-number').text(num)
      socket.on 'disconnect article', (num) ->
        $('#article-connection #article-number').text(num)

      #記事ページのみ
      unless article is ''

        #keyupごとに
        $('#content-editable').keyup (e) ->
          #編集したことを通知
          res = {}
          res.msg = $("#content-editable").html()
          res.article = article
          socket.emit "msg send",res

        #他の画面で編集がされたとき
        socket.on "msg push", (msg) ->
          #console.log "other user editted"
          console.log msg.replace '"', ''
          $("#content-editable").html(msg)

        socket.on "msg updateDB", (msg) ->
          console.log msg

###
$ ->
  Router = Backbone.Router.extend(
    routes:
      "": "index"
      "about": "about"

    initialize: ->
      @con = $("#content")

    index: ->
      $("#content").hide("slide","100")
      @con.load "/ #content",  ->
        $("#content").show("slide","100")

    about: ->
      $("#content").hide("slide","100")
      @con.load "/home/about #content", ->
        $("#content").show("slide","100")
  )
  window.router = new Router()
  Backbone.history.start pushState: true

  # button
  $("a#home").click ->
    window.router.navigate "",
      trigger: true
  $("a#about").click ->
    window.router.navigate "about",
      trigger: true
###