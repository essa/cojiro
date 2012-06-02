App.Thread = App.Models.Thread = Backbone.Model.extend
  defaults:
    title: ''
    summary: ''
    created_at: ''

  toJSON: -> thread: @attributes
  getId: -> @id
  getTitle: -> @get('title')
  getSummary: -> @get('summary')
  getCreatedAt: -> @toDateStr(@get('created_at'))
  getSourceLanguage: -> @get('source_language')
  getUserName: -> @get('user').name
  getUserFullname: -> @get('user').fullname

  validate: (attrs) ->
    errors = []
    if (!attrs.title) then errors.push "cannot have an empty title"
    return errors unless errors.length is 0

  toDateStr: (seconds) ->
    I18n.strftime(new Date(seconds * 1000), "%B %e, %Y")
