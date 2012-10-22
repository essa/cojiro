define [
  'jquery'
  'underscore'
  'backbone'
  'globals'
  'routers/app_router'
  'collections/threads'
], ($, _, Backbone, globals, AppRouter, Threads) ->

  init: () ->
    @currentUser = globals.current_user
    @threads = new Threads()
    @threads.deferred = @threads.fetch()
    self = @

    @threads.deferred.done ->
      self.appRouter = new AppRouter(collection: self.threads)

      if (!Backbone.history.started)
        Backbone.history.start(pushState: true)
        Backbone.history.started = true
