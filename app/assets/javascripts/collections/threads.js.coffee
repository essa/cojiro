define [
  'jquery'
  'underscore'
  'backbone'
  'models/thread'
  'globals'
], ($, _, Backbone, Thread, globals) ->

  class Threads extends Backbone.Collection
    model: Thread
    url: ->
      '/' + globals.locale + '/threads'

    byUser: (username) ->
      new @constructor(@select((thread) -> (thread.getUserName() == username )))

  return Threads
