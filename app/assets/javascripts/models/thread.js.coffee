class App.Thread extends Backbone.Model
  defaults: ->
    title: ''
    summary: ''
    source_locale: I18n.locale

  schema: ->
    title:
      title: _(I18n.t("attributes.thread.title")).capitalize()
      type: 'Text'
    summary:
      type: 'TextArea'
      title: _(I18n.t("attributes.thread.summary")).capitalize()

  # http://stackoverflow.com/questions/5306089/only-update-certain-model-attributes-using-backbone-js
  toJSON: () ->
    thread:
      title: @get('title')
      summary: @get('summary')
      source_locale: @get('source_locale')

  getAttrInSourceLocale: (attr_name) -> @get("#{attr_name}_in_source_locale")
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
    errors = {}

    if (attrs.title is "") and (!attrs.source_locale? or attrs.source_locale is I18n.locale)
      errors.title = I18n.t('errors.messages.blank')
    if (attrs.source_locale is "")
      errors.source_locale = I18n.t('errors.messages.blank')

    if !_.isEmpty(errors) then return errors

  toDateStr: (datetime) ->
    I18n.l("date.formats.long", datetime) unless datetime is undefined

App.Models.Thread = App.Thread
