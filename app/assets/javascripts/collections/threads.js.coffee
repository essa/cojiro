class App.Threads extends Backbone.Collection
  model: App.Thread
  url: ->
    '/' + I18n.locale + '/threads'

  byUser: (username) ->
    new @constructor(@select((thread) -> (thread.getUserName() == username )))

App.Collections.Threads = App.Threads
