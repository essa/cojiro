define [
  'underscore',
  'backbone',
  'modules/base',
  'modules/translatable/attribute',
  'i18n'
], (_, Backbone, Base, TranslatableAttribute, I18n) ->
  class TranslatableModel extends Base.Model

    initialize: (attributes, options) ->
      if @translatableAttributes = (options? && options.translatableAttributes) || []
        self = this
        _.each @translatableAttributes, (attr) ->
          self.set(attr, new TranslatableAttribute)

    parse: (response) ->
      if @translatableAttributes?
        for key in @translatableAttributes
          value = response[key]
          response[key] = new TranslatableAttribute(value, parse: true)
      return response

    getAttrInLocale: (attr_name, locale) -> @get(attr_name).get(locale)
    getAttr: (attr_name) -> @getAttrInLocale(attr_name, I18n.locale)
    getAttrInSourceLocale: (attr_name) -> @getAttrInLocale(attr_name, @getSourceLocale())
    getSourceLocale: -> @get('source_locale')

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
