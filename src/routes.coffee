#### Routes
# We are setting up theese routes:
#
# GET, POST, PUT, DELETE methods are going to the same controller methods - we dont care.
# We are using method names to determine controller actions for clearness.

module.exports = (app) ->

  #  index
  app.all '/', (req, res, next) ->
    res.render "index"

  #  ページ一覧
  app.all '/:name', (req, res, next) ->
    res.render "article", { name: req.params.name  }

  #  記事
  app.all '/:name/:article', (req, res, next) ->
    res.render "article",{ name: req.params.name, article:req.params.article   }

  # If all else failed, show 404 page
  app.all '/*', (req, res) ->
    console.warn "error 404: ", req.url
    res.statusCode = 404
    res.render '404', 404
