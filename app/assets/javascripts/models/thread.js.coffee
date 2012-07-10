App.Thread = App.Models.Thread = Backbone.Model.extend
  defaults:
    title: ''
    summary: ''

  schema:
    title:
      type: 'Text'
      validators: [
        type: 'required',
        message: "can\'t be blank"
      ]
    summary: 'TextArea'

  toJSON: -> thread: @attributes
  getId: -> @id
  getTitle: -> @get('title')
  getSummary: -> @get('summary')
  getCreatedAt: -> @toDateStr(@get('created_at'))
  getSourceLanguage: -> @get('source_language')
  getUserName: -> @get('user').name
  getUserFullname: -> @get('user').fullname
  getUserAvatarUrl: -> @get('user').avatar_url
  getUserAvatarMiniUrl: -> @get('user').avatar_mini_url

  validate: (attrs) ->
    errors = []
    if (!attrs.title) then errors.push "cannot have an empty title"
    return errors unless errors.length is 0

  toDateStr: (datetime) ->
    I18n.l("date.formats.long", datetime)
