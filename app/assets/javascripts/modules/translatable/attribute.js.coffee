define [
  'underscore',
  'backbone',
  'modules/base/model',
  'i18n'
], (_, Backbone, BaseModel, I18n) ->
  class TranslatableAttribute extends BaseModel

    in: (attr) -> @get(attr)

    validate: (attrs) -> false
