App.Threads = App.Collections.Threads = Backbone.Collection.extend
  model: App.Thread
  url: ->
    '/' + I18n.locale + '/threads'
