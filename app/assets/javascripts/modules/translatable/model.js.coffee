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
        self = this
        _.each @translatableAttributes, (attr) ->
          self.set(attr, new TranslatableAttribute(_.isObject(attributes) && attributes[attr]))

    parse: (response) ->
      if response? && @translatableAttributes?
        for key in @translatableAttributes
          if value = response[key]
            response[key] = new TranslatableAttribute(value, parse: true)
      return response

    getAttrInLocale: (attr_name, locale) -> @get(attr_name).get(locale)
    getAttr: (attr_name) -> @getAttrInLocale(attr_name, I18n.locale)
    getAttrInSourceLocale: (attr_name) -> @getAttrInLocale(attr_name, @getSourceLocale())
    getSourceLocale: -> @get('source_locale')

    set: (attributes, options) ->
      parsed_attributes = JSON.parse(JSON.stringify(attributes))
      parsed_attributes = @parse(parsed_attributes)
      super(parsed_attributes, options)

    setAttrInLocale: (attr_name, locale, value) ->
      attr = @get(attr_name)
      attr.set(locale, value)
      @set(attr_name, attr)
    setAttr: (attr_name, value) -> @setAttrInLocale(attr_name, I18n.locale, value)

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (attrs.source_locale is '' or attrs.source_locale is null)
        errors.source_locale = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors
