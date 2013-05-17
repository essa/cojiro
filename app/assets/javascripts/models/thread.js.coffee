define [
  'underscore'
  'backbone'
  'i18n'
  'modules/translatable'
  'modules/extended/timestamps'
  'underscore_mixins'
], (_, Backbone, I18n, Translatable, Timestamps) ->

  class Thread extends Translatable.Model
    @use(Timestamps)

    translatableAttributes:
      [ 'title', 'summary' ]

    defaults: ->
      source_locale: I18n.locale

    schema: ->
      title:
        type: 'Text'
        label: _(I18n.t('attributes.thread.title')).capitalize()
      summary:
        type: 'TextArea'
        label: _(I18n.t('attributes.thread.summary')).capitalize()

    # http://stackoverflow.com/questions/5306089/only-update-certain-model-attributes-using-backbone-js
    toJSON: () ->
      thread:
        title: @get('title').toJSON()
        summary: @get('summary').toJSON()
        source_locale: @get('source_locale')

    getId: -> @id
    getUserName: -> @get('user').name
    getUserFullname: -> @get('user').fullname
    getUserAvatarUrl: -> @get('user').avatar_url
    getUserAvatarMiniUrl: -> @get('user').avatar_mini_url

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (source_locale = attrs.source_locale)
        title = attrs.title
        unless title && title[source_locale] || (_(title.in).isFunction() && title.in(source_locale))
          errors.title = {}
          errors.title[source_locale] = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors

    toDateStr: (datetime) ->
      I18n.l('date.formats.long', datetime) unless datetime is undefined
