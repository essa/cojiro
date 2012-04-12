CojiroApp.Models.Cothread = Backbone.Model.extend
  url: ->
    if this.isNew()
      return '/threads.json'
    else
      return '/threads/' + this.getId() + '.json'

  defaults:
    title: ''
    summary: ''

  toJSON: ->
    { cothread: this.attributes }

  getId: ->
    return this.id

  getTitle: ->
    return this.get('title')

  getSummary: ->
    return this.get('summary')
