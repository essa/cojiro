define [
  'jquery',
  'underscore',
  'backbone',
  'models/thread'
], ($, _, Backbone, Thread) ->

  class Threads extends Backbone.Collection
    model: Thread
    url: ->
      '/' + I18n.locale + '/threads'

    byUser: (username) ->
      new @constructor(@select((thread) -> (thread.getUserName() == username )))

  return Threads
