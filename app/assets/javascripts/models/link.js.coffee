define [
  'underscore'
  'backbone'
  'i18n'
  'modules/translatable'
  'underscore_mixins'
], (_, Backbone, I18n, Translatable) ->

  class Link extends Translatable.Model
    translatableAttributes:
      [ 'title' ]

    defaults: ->
      source_locale: I18n.locale

    toJSON: () ->
      link:
        title: @get('title').toJSON()
        source_locale: @get('source_locale')

    getId: -> @id
    getCreatedAt: -> @toDateStr(@get('created_at'))
    getUpdatedAt: -> @toDateStr(@get('updated_at'))
    getUserName: -> @get('user').name
    getUserFullname: -> @get('user').fullname
    getUserAvatarUrl: -> @get('user').avatar_url
    getUserAvatarMiniUrl: -> @get('user').avatar_mini_url

    toDateStr: (datetime) ->
      I18n.l('date.formats.long', datetime) unless datetime is undefined
