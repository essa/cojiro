define [
  'jquery'
  'underscore'
  'backbone'
  'models/thread'
  'i18n'
], ($, _, Backbone, Thread, I18n) ->

  class Threads extends Backbone.Collection
    model: Thread
    url: ->
      '/' + I18n.locale + '/threads'

    byUser: (username) ->
      new @constructor(@select((thread) -> (thread.getUserName() == username )))

  return Threads
