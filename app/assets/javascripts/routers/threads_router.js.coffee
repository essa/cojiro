class CojiroApp.Routers.Threads extends Backbone.Router
  routes:
    "" : "show"

  show: ->
    view = new CojiroApp.Views.ThreadsShow( model: CojiroApp.thread )
    $('.content').html(view.render().el)
