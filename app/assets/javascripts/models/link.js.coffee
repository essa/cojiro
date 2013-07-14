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

    idAttribute: 'url'

    url: ->
      throw('id is required to generate url') unless @id
      base = '/' + I18n.locale + '/links'
      if @id then base += ('/' + encodeURIComponent(@id))
      base

    relations: [
        type: Backbone.HasOne
        key: 'user'
        relatedModel: User
        autoFetch: true
        reverseRelation:
          key: 'links'
          includeInJSON: 'name'
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

    schema: ->
      title:
        type: 'Text'
        label: _(I18n.t('attributes.link.title')).capitalize()
      summary:
        type: 'TextArea'
        label: _(I18n.t('attributes.link.summary')).capitalize()

    toJSON: () ->
      link:
        title: @get('title').toJSON()
        summary: @get('summary').toJSON()
        source_locale: @get('source_locale')

    getId: -> @id
    getUser: -> @get('user')
    getUrl: -> @get('url')
    getSiteName: -> @get('site_name')

  # http://backbonerelational.org/#RelationalModel-setup
  Link.setup()
