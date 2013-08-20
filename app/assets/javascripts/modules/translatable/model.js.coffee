define [
  'jquery',
  'underscore',
  'backbone',
  'modules/base/model',
  'modules/translatable/attribute',
  'i18n'
], ($, _, Backbone, BaseModel, TranslatableAttribute, I18n) ->

  duplicate = (obj) -> obj && JSON.parse(JSON.stringify(obj))

  class TranslatableModel extends BaseModel

    translatableAttributes: []

    initialize: (attributes, options) ->
      if _.isArray(@translatableAttributes)
        self = @
        _.each @translatableAttributes, (attr) ->
          value = _.isObject(attributes) && duplicate(attributes[attr])
          self._set(attr, new TranslatableAttribute(value))

    parse: (resp, options = {}) ->
      return unless resp
      for key in @translatableAttributes
        if resp[key]
          resp[key] = duplicate(resp[key])
        value = resp[key]
        if options.merge && value
          value ||= {}
          oldValue = @get(key) && @get(key).attributes
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
    setSourceLocale: (locale) -> @set('source_locale', locale)

    validate: (attrs) ->
      errors = super(attrs) || {}
      return !_.isEmpty(errors) && errors
