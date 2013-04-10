define [
  'underscore',
  'backbone',
  'modules/base',
  'i18n'
], (_, Backbone, Base, I18n) ->
  class TranslatableAttribute extends Base.Model

    in: (attr) -> @get(attr)

    validate: (attrs) -> false
