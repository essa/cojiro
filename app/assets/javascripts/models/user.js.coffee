define [
  'underscore'
  'backbone'
  'i18n'
  'modules/base'
  'modules/extended/timestamps'
], (_, Backbone, I18n, Base, Timestamps) ->

  class User extends Base.Model
    @use(Timestamps)
