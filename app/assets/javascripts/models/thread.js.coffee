define [
  'underscore'
  'backbone'
  'i18n'
  'modules/translatable'
  'models/user'
  'models/comment'
  'collections/comments'
  'modules/extended/timestamps'
  'underscore-mixins'
], (_, Backbone, I18n, Translatable, User, Comment, Comments, Timestamps) ->

  class Thread extends Translatable.Model
    @use(Timestamps)

    name: 'thread'

    relations: [
        type: Backbone.HasOne
        key: 'user'
        relatedModel: User
        reverseRelation:
          key: 'threads'
          includeInJSON: 'name'
      ,
        type: Backbone.HasMany
        key: 'comments'
        relatedModel: Comment
        collectionType: Comments
        reverseRelation:
          key: 'thread'
          keySource: 'thread_id'
          includeInJSON: false
    ]

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
      title: @get('title').toJSON()
      summary: @get('summary').toJSON()
      source_locale: @get('source_locale')

    getId: -> @id
    getUser: -> @get('user')
    getUserName: -> @getUser().getName()
    getComments: -> @get('comments')
    getLinks: -> @getComments().pluck('link')

    hasLink: (url) ->
      link = _(@getLinks()).find (link) -> link.getUrl() is url
      return link?

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (attrs.source_locale is '' or attrs.source_locale is null)
        errors.source_locale = I18n.t('errors.messages.blank')

      if (source_locale = attrs.source_locale)
        title = attrs.title
        unless title && title[source_locale] || (_(title.in).isFunction() && title.in(source_locale))
          errors.title = {}
          errors.title[source_locale] = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors

  # http://backbonerelational.org/#RelationalModel-setup
  Thread.setup()
