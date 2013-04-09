$ ->

  # 同じwikinameに居る人としか通信しない
  # Backbone.jsとかで書いたほうが綺麗?
  url = document.URL.split "/"
  wikiname =  url[3]
  articlename = url[4]

  # トップページ以外
less wikiname is ''  un

    socket = io.connect 'http://localhost'
    socket.on "connect", ->
      console.log "connected"

      #同じwikiに居る人とのみ繋がる

      #新しいユーザが来たとき
      socket.on 'connect push', ->

      #ユーザが減った時
      socket.on 'disconnect push', ->

      unless articlename is ''

        #keyupごとに
        $('#content-editable').keyup (e)->
          #console.log e

          #編集したことを通知
          socket.emit "msg send", $("#content-editable").html()

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