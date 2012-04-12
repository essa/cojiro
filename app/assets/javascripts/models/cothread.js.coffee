CojiroApp.Models.Cothread = Backbone.Model.extend
  url: ->
    if this.isNew()
      '/threads.json'
    else
      '/threads/' + this.getId() + '.json'

  defaults:
    title: ''
    summary: ''

  toJSON: -> { cothread: this.attributes }
  getId: -> this.id
  getTitle: -> this.get('title')
  getSummary: -> this.get('summary')
