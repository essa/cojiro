class CojiroApp.Collections.Threads extends Backbone.Collection
  model: CojiroApp.Models.Thread
  url: ->
    '/' + I18n.locale + '/threads'
