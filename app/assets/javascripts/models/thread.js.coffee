App.Thread = App.Models.Thread = Backbone.Model.extend
  defaults:
    title: ''
    summary: ''

  schema: ->
    title:
      title: _(I18n.t("attributes.thread.title")).capitalize()
      type: 'Text'
      validators: [
        type: 'required',
        message: I18n.t("errors.messages.blank")
      ]
    summary:
      type: 'TextArea'
      title: _(I18n.t("attributes.thread.summary")).capitalize()

  toJSON: -> thread: @attributes
  getAttrInSourceLocale: (attr_name) -> @get("#{attr_name}_in_source_locale")
  getAttrWithSource: (attr_name) ->
    current: @get(attr_name),
    source: @getAttrInSourceLocale(attr_name)
  getId: -> @id
  getTitle: -> @get('title')
  getSummary: -> @get('summary')
  getCreatedAt: -> @toDateStr(@get('created_at'))
  getSourceLocale: -> @get('source_locale')
  getUserName: -> @get('user').name
  getUserFullname: -> @get('user').fullname
  getUserAvatarUrl: -> @get('user').avatar_url
  getUserAvatarMiniUrl: -> @get('user').avatar_mini_url

  validate: (attrs) ->
    errors = []
    if (!attrs.title) then errors.push "cannot have an empty title"
    return errors unless errors.length is 0

  toDateStr: (datetime) ->
    I18n.l("date.formats.long", datetime) unless datetime is undefined
