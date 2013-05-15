define [
  'underscore'
  'backbone'
  'i18n'
  'modules/translatable'
  'modules/extended/timestamps'
  'underscore_mixins'
], (_, Backbone, I18n, Translatable, Timestamps) ->

  class Link extends Translatable.Model
    @extendObject(Timestamps)

    translatableAttributes:
      [ 'title' ]

    defaults: ->
      source_locale: I18n.locale

    toJSON: () ->
      link:
        title: @get('title').toJSON()
        source_locale: @get('source_locale')

    getId: -> @id
    getUserName: -> @get('user').name
    getUserFullname: -> @get('user').fullname
    getUserAvatarUrl: -> @get('user').avatar_url
    getUserAvatarMiniUrl: -> @get('user').avatar_mini_url
