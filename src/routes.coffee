#### Routes
# We are setting up theese routes:
#
# GET, POST, PUT, DELETE methods are going to the same controller methods - we dont care.
# We are using method names to determine controller actions for clearness.

module.exports = (app) ->

  db = require('redis').createClient()

  #  index
  app.get '/', (req, res, next) ->
    res.render "index"

  #  ページ一覧
  app.get '/:wiki', (req, res, next) ->
    db.keys req.params.wiki+'*', (err, reply) ->
      reply = "" if reply is null
      #console.log reply
      res.render "list", { wiki: req.params.wiki, articles:reply }

  #  記事
  app.get '/:wiki/:article', (req, res, next) ->
    db.zrevrange req.params.wiki+":"+req.params.article,0,1, (err,members) ->
      console.log "memb:"+members
      console.log members.class
      #console.log req.params.wiki+":"+req.params.article
      if members is undefined
        res.render "article", { wiki:req.params.wiki, article:req.params.article,content:"" }
      else
        res.render "article",{ wiki: req.params.wiki, article:req.params.article, content:members[0]  }

  # If all else failed, show 404 page
  app.all '/*', (req, res) ->
    console.warn "error 404: ", req.url
    res.statusCode = 404
    res.render '404', 404
