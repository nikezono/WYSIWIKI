express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
socketio = require 'socket.io'
mongoose = require 'mongoose'
url = require 'url'
http = require 'http'


#### Basic application initialization
# Create app instance.
app = express()
server = http.createServer app
io = socketio.listen server

server.listen 8000


## socket.io
io.sockets.on "connection", (socket) ->
  console.log 'connected'

  socket.on 'init', (req) ->
    #以下いらない?
    socket.set 'wiki',req.wiki
    socket.set 'article', req.article

    ## ユーザが増えたことを通知

    #roomに入れて管理する
    socket.join req.wiki
    socket.join req.article unless req.article is undefined

    #roomに接続数を通知
    io.sockets.to(req.wiki).emit 'connect wiki', io.sockets.clients(req.wiki).length
    io.sockets.to(req.article).emit 'connect article', io.sockets.clients(req.article).length

  #他の画面で編集が行われたら
  socket.on "msg send", (res) ->
    io.sockets.to(res.article).emit 'msg push',res.msg

  ##ユーザが減ったことを通知
  socket.on "disconnect",(req) ->
    console.log "disconnected"

    #roomから出る
    socket.leave req.wiki
    socket.leave req.article unless req.article is undefined

    #roomに接続数を通知
    io.sockets.to(req.wiki).emit 'disconnect wiki',io.sockets.clients(req.wiki).length-1
    io.sockets.to(req.article).emit 'disconnect article', io.sockets.clients(req.article).length-1

# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment app.settings.env

# db_config = "mongodb://#{config.DB_USER}:#{config.DB_PASS}@#{config.DB_HOST}:#{config.DB_PORT}/#{config.DB_NAME}"
# mongoose.connect db_config
if app.settings.env != 'production'
  mongoose.connect 'mongodb://localhost/example'
else
  console.log('If you are running in production, you may want to modify the mongoose connect path')

#### View initialization
# Add Connect Assets.
app.use assets()
# Set the public folder as static assets.
app.use express.static(process.cwd() + '/public')


# Set View Engine.
app.set 'view engine', 'jade'

# [Body parser middleware](http://www.senchalabs.org/connect/middleware-bodyParser.html) parses JSON or XML bodies into `req.body` object
app.use express.bodyParser()


#### Finalization
# Initialize routes
routes = require './routes'
routes(app)

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3030

app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."

