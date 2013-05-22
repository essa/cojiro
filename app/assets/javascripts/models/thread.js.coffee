define [
  'underscore'
  'backbone'
  'i18n'
  'modules/translatable'
  'models/user'
  'models/comment'
  'collections/comments'
  'modules/extended/timestamps'
  'underscore_mixins'
], (_, Backbone, I18n, Translatable, User, Comment, Comments, Timestamps) ->

  class Thread extends Translatable.Model
    @use(Timestamps)

    relations: [
        type: Backbone.HasOne
        key: 'user'
        relatedModel: User
        reverseRelation:
          key: 'threads'
          includeInJSON: 'id'
      ,
        type: Backbone.HasMany
        key: 'comments'
        relatedModel: Comment
        collectionType: Comments
        reverseRelation:
          key: 'thread'
          includeInJSON: 'id'
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
      thread:
        title: @get('title').toJSON()
        summary: @get('summary').toJSON()
        source_locale: @get('source_locale')

    # user relation
    getUserName: -> @get('user').get('name')
    getUserFullname: -> @get('user').get('fullname')
    getUserAvatarUrl: -> @get('user').get('avatar_url')
    getUserAvatarMiniUrl: -> @get('user').get('avatar_mini_url')

    # links relation through comments
    getLinks: -> @get('comments').pluck('link')

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (source_locale = attrs.source_locale)
        title = attrs.title
        unless title && title[source_locale] || (_(title.in).isFunction() && title.in(source_locale))
          errors.title = {}
          errors.title[source_locale] = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors

  # http://backbonerelational.org/#RelationalModel-setup
  Thread.setup()
