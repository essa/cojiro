class CojiroApp.Models.Thread extends Backbone.Model
  url: ->
    if @isNew()
      '/' + I18n.locale + '/threads'
    else
      '/' + I18n.locale + '/threads/' + @getId()

  defaults:
    title: ''
    summary: ''
    created_at: ''

  toJSON: -> thread: @attributes
  getId: -> @id
  getTitle: -> @get('title')
  getSummary: -> @get('summary')
  getCreatedAt: -> @get('created_at')
  getSourceLanguage: -> @get('source_language')

  validate: (attrs) ->
    if (!attrs.title) then "cannot have an empty title"
