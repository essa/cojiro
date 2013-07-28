define [
  'jquery'
  'backbone'
  'globals'
  'routers/app_router'
  'collections/threads'
  'collections/links'
], ($, Backbone, globals, AppRouter, Threads, Links) ->

  class App

    constructor: (options = {}) ->
      # isolate dependencies
      @globals = options.globals || globals
      @Threads = options.Threads || Threads
      @AppRouter = options.AppRouter || AppRouter

    init: () ->
      @currentUser = @globals.currentUser
      @threads = new @Threads
      @threads.deferred = @threads.fetch()
      self = @

      @threads.deferred.done ->
        self.appRouter = new self.AppRouter(collection: self.threads)

        if (!Backbone.history.started)
          Backbone.history.start(pushState: true)
          Backbone.history.started = true
