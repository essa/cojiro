define [
  'backbone'
  'models/link'
  'i18n'
], (Backbone, Link, I18n) ->

  class Links extends Backbone.Collection
    model: Link
    url: ->
      '/' + I18n.locale + '/links'
