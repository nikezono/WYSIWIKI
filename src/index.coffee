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

#uri = url.parse(request.url).pathname

io.sockets.on "connection", (socket,url) ->
  console.log 'connected' + uri

  #ユーザが増えたことを通知
  socket.broadcast.emit 'connect push',url

  #他の画面で編集が行われたら
  socket.on "msg send", (msg) ->
    socket.broadcast.emit 'msg push' ,msg

  #ユーザが減ったことを通知
  socket.on "disconnect", ->
    socket.broadcast.emit 'disconnect push', 'disconnect'
    #console.log 'disconnected'

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

