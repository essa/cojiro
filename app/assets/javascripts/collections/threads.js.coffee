class App.Threads extends Backbone.Collection
  model: App.Thread
  url: ->
    '/' + I18n.locale + '/threads'

App.Collections.Threads = App.Threads
