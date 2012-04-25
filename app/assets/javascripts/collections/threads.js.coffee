class App.Collections.Threads extends Backbone.Collection
  model: App.Models.Thread
  url: ->
    '/' + I18n.locale + '/threads'
