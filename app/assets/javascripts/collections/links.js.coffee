define [
  'backbone'
  'models/link'
], (Backbone, Link) ->

  class Links extends Backbone.Collection
    model: Link
    url: ->
      '/' + I18n.locale + '/links'
