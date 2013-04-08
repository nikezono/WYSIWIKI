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
