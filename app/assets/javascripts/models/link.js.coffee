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
      [ 'title' ]

    defaults: ->
      source_locale: I18n.locale

    toJSON: () ->
      link:
        title: @get('title').toJSON()
        source_locale: @get('source_locale')

    getId: -> @id
    getUserName: -> @get('user').get('name')
    getUserFullname: -> @get('user').get('fullname')
    getUserAvatarUrl: -> @get('user').get('avatar_url')
    getUserAvatarMiniUrl: -> @get('user').get('avatar_mini_url')

  # http://backbonerelational.org/#RelationalModel-setup
  Link.setup()
