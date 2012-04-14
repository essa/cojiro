class CojiroApp.Routers.Cothreads extends Backbone.Router
  routes:
    "" : "show"

  show: ->
    view = new CojiroApp.Views.CothreadsShow( model: CojiroApp.cothread )
    $('.content').html(view.render().el)
