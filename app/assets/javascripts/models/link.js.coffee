define [
  'underscore'
  'backbone'
  'i18n'
  'modules/translatable/model'
  'models/user'
  'models/comment'
  'collections/comments'
  'modules/extended/timestamps'
  'underscore_mixins'
], (_, Backbone, I18n, TranslatableModel, User, Comment, Comments, Timestamps) ->

  class Link extends TranslatableModel
    @use(Timestamps)

    idAttribute: 'id'
    name: 'link'

    url: ->
      throw('url attribute is required to generate link url') unless (url = @getUrl())
      "/#{I18n.locale}/links/#{encodeURIComponent(url)}"

    sync: (method, model, options) ->
      # force both create and update to use PUT
      if (method == 'create')
        method = 'update'
      super(method, model, options)

    parse: (resp, options = {}) ->
      resp = resp && JSON.parse(JSON.stringify(resp))
      if resp? && (id = resp[@idAttribute])
        coll = Backbone.Relational.store.getCollection(@)
        duplicate = coll && coll.get(id)
        if (duplicate && (@ != duplicate))
          delete(resp[@idAttribute])
      super

    relations: [
        type: Backbone.HasOne
        key: 'user'
        keySource: 'user_name'
        relatedModel: User
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
          keyDestination: 'link_attributes'
          includeInJSON: true
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
      url = @getUrl()
      title = @get('title').toJSON()
      summary = @get('summary').toJSON()
      source_locale = @getSourceLocale()
      if !_.isEmpty(title) || !_.isEmpty(summary) || source_locale?
        url: url
        title: title
        summary: summary
        source_locale: source_locale
      else {}

    getId: -> @id
    getUser: -> @get('user')
    getUserName: -> @get('user_name')
    getUrl: -> @get('url')
    getDisplayUrl: -> @get('display_url')
    getSiteName: -> @get('site_name')
    getEmbedData: -> @get('oembed_data') || {}
    getThumbnailUrl: ->  @getEmbedData()['thumbnail_url']
    getStatus: -> @getSourceLocale() && 1 || 0

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
