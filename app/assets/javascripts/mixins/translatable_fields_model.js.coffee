define [
  'underscore',
  'backbone',
  'mixins/base_model',
  'i18n'
], (_, Backbone, BaseModel, I18n) ->
  class TranslatableFieldsModel extends BaseModel

    getAttrInSourceLocale: (attr_name) -> @get("#{attr_name}_in_source_locale")
    getSourceLocale: -> @get('source_locale')

    validate: (attrs) ->
      errors = super(attrs) || {}

      if (attrs.source_locale is '' or attrs.source_locale is null)
        errors.source_locale = I18n.t('errors.messages.blank')

      return !_.isEmpty(errors) && errors
