define [
  'underscore'
  'backbone'
  'i18n'
  'models/user'
  'modules/translatable'
  'modules/extended/timestamps'
  'underscore_mixins'
], (_, Backbone, I18n, User, Translatable, Timestamps) ->

  class Link extends Translatable.Model
    @use(Timestamps)

    relations: [
      type: Backbone.HasOne
      key: 'user'
      relatedModel: User
      reverseRelation:
        key: 'links'
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
