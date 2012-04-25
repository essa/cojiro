App.Thread = App.Models.Thread = Backbone.Model.extend
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
  getUserName: -> @get('user').name
  getUserFullname: -> @get('user').fullname

  validate: (attrs) ->
    errors = []
    if (!attrs.title) then errors.push "cannot have an empty title"
    if (!attrs.user) then errors.push "cannot have an empty user"
    return errors unless errors.length is 0
