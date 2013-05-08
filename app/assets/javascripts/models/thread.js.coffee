define [
  'underscore'
  'backbone'
  'i18n'
  'modules/translatable'
  'underscore_mixins'
], (_, Backbone, I18n, Translatable) ->

  class Thread extends Translatable.Model
    translatableAttributes:
      [ "title", "summary" ]

    defaults: ->
      source_locale: I18n.locale

    schema: ->
      title:
        label: _(I18n.t("attributes.thread.title")).capitalize()
        type: 'Text'
      summary:
        type: 'TextArea'
        label: _(I18n.t("attributes.thread.summary")).capitalize()

    # http://stackoverflow.com/questions/5306089/only-update-certain-model-attributes-using-backbone-js
    toJSON: () ->
      thread:
        title: @get('title').toJSON()
        summary: @get('summary').toJSON()
        source_locale: @get('source_locale')

    getId: -> @id
    getTitle: -> @getAttr('title')
    getSummary: -> @getAttr('summary')
    getCreatedAt: -> @toDateStr(@get('created_at'))
    getUpdatedAt: -> @toDateStr(@get('updated_at'))
    getUserName: -> @get('user').name
    getUserFullname: -> @get('user').fullname
    getUserAvatarUrl: -> @get('user').avatar_url
    getUserAvatarMiniUrl: -> @get('user').avatar_mini_url

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (source_locale = attrs.source_locale)
        if attrs.title? and (attrs.title.in(source_locale) is "")
          errors.title = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors

    toDateStr: (datetime) ->
      I18n.l("date.formats.long", datetime) unless datetime is undefined

  return Thread
