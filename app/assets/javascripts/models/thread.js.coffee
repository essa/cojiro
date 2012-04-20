class CojiroApp.Models.Thread extends Backbone.Model
  url: ->
    if @isNew()
      '/threads'
    else
      '/threads/' + @getId()

  defaults:
    title: ''
    summary: ''
    created_at: ''

  toJSON: -> thread: @attributes
  getId: -> @id
  getTitle: -> @get('title')
  getSummary: -> @get('summary')
  getCreatedAt: -> @get('created_at')
