define [
  'underscore',
  'backbone',
  'modules/base/model',
  'i18n'
], (_, Backbone, BaseModel, I18n) ->
  class TranslatableAttribute extends BaseModel

    in: (locale) ->
      val = @get(locale)
      val &&= val.trim()
      if val == '' then undefined else val
