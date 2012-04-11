CojiroApp.Models.Cothread = Backbone.Model.extend
  defaults:
    title: ''
    summary: ''

  getId: ->
    return this.id
