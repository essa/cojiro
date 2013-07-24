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
      source_locale:
        type: 'Select'
        label: I18n.t('attributes.link.source_locale')
        values: _('': 'Select a language').extend(
          _.object(_(I18n.availableLocales).map (locale) -> [locale, I18n.t(locale)]))
      title:
        type: 'TextArea'
        label: _(I18n.t('attributes.link.title')).capitalize()
      summary:
        type: 'TextArea'
        label: _(I18n.t('attributes.link.summary')).capitalize()

    toJSON: () ->
      title = @get('title').toJSON()
      summary = @get('summary').toJSON()
      source_locale = @get('source_locale')
      if !_.isEmpty(title) || !_.isEmpty(summary) || source_locale?
        link:
          title: title
          summary: summary
          source_locale: source_locale
      else {}

    getId: -> @id
    getUser: -> @get('user')
    getUrl: -> @get('url')
    getSiteName: -> @get('site_name')
    getEmbedData: -> @get('embed_data') || {}
    getThumbnailUrl: ->  @getEmbedData()['thumbnail_url']

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (attrs.url is '' or attrs.url is null)
        errors.url = I18n.t('errors.messages.blank')

      sourceLocale = attrs.source_locale

      if (sourceLocale == '' || sourceLocale == null)
        errors.source_locale = I18n.t('errors.messages.blank')
      else
        if (title = attrs.title) instanceof Backbone.Model
          title = title.attributes

        if _.isEmpty(title) || (title[sourceLocale] == '') || (title[sourceLocale] == null)
          (errors.title = {})[sourceLocale] = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors

  # http://backbonerelational.org/#RelationalModel-setup
  Link.setup()
