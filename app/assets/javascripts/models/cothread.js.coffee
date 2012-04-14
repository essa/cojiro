class CojiroApp.Models.Cothread extends Backbone.Model
  url: ->
    if @isNew()
      '/threads'
    else
      '/threads/' + @getId()

  defaults:
    title: ''
    summary: ''

  toJSON: -> cothread: @attributes
  getId: -> @id
  getTitle: -> @get('title')
  getSummary: -> @get('summary')
