define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base',
  'modules/translatable/attribute',
  'i18n'
], ($, _, Backbone, Base, TranslatableAttribute, I18n) ->
  class TranslatableModel extends Base.Model

    translatableAttributes: []

    initialize: (attributes, options) ->
      if _.isArray(@translatableAttributes)
        self = @
        _.each @translatableAttributes, (attr) ->
          self._set(attr, new TranslatableAttribute(_.isObject(attributes) && attributes[attr]))

    parse: (resp, options = {}) ->
      self = @
      resp = JSON.parse(JSON.stringify(resp))
      if resp? && @translatableAttributes?
        for key in @translatableAttributes
          value = resp[key]
          if options.merge && !!value
            value ||= {}
            oldValue = self.get(key) && self.get(key).attributes
            _(value).extend oldValue
          if value
            resp[key] = new TranslatableAttribute(value, parse: true)
      return resp

    getAttrInLocale: (attr_name, locale) -> @get(attr_name).get(locale)
    getAttr: (attr_name) -> @getAttrInLocale(attr_name, I18n.locale)
    getAttrInSourceLocale: (attr_name) -> @getAttrInLocale(attr_name, @getSourceLocale())
    getSourceLocale: -> @get('source_locale')

    _set: (key, val, options) ->
      @constructor.__super__.set.call(@, key, val, options)

    set: (key, val, options) ->
      if typeof key is 'object'
        attrs = key
        options = val
      else (attrs = {})[key] = val
      super(@parse(attrs, merge: true), options)

    setAttrInLocale: (attr_name, locale, value) ->
      attr = @get(attr_name)
      attr.set(locale, value)
      @_set(attr_name, attr)
    setAttr: (attr_name, value) -> @setAttrInLocale(attr_name, I18n.locale, value)

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (attrs.source_locale is '' or attrs.source_locale is null)
        errors.source_locale = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors
