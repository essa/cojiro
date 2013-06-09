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

  class Link extends Translatable.Model
    @use(Timestamps)

    relations: [
        type: Backbone.HasOne
        key: 'user'
        relatedModel: User
        reverseRelation:
          key: 'links'
          includeInJSON: 'id'
      ,
        type: Backbone.HasMany
        key: 'comments'
        relatedModel: Comment
        collectionType: Comments
        reverseRelation:
          key: 'link'
          includeInJSON: 'id'
    ]

    translatableAttributes:
      [ 'title', 'summary' ]

    defaults: ->
      source_locale: I18n.locale

    toJSON: () ->
      link:
        title: @get('title').toJSON()
        summary: @get('summary').toJSON()
        source_locale: @get('source_locale')
        url: @get('url')

    getId: -> @id
    getUser: -> @get('user')

  # http://backbonerelational.org/#RelationalModel-setup
  Link.setup()
