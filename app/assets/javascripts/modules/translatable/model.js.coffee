define [
  'underscore',
  'backbone',
  'modules/base',
  'modules/translatable/attribute',
  'i18n'
], (_, Backbone, Base, TranslatableAttribute, I18n) ->
  class TranslatableModel extends Base.Model

    getAttrInSourceLocale: (attr_name) -> @get("#{attr_name}_in_source_locale")
    getSourceLocale: -> @get('source_locale')

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

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (attrs.source_locale is '' or attrs.source_locale is null)
        errors.source_locale = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors
