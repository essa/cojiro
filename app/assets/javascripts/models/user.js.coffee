define [
  'underscore'
  'backbone'
  'i18n'
  'modules/base'
  'modules/extended/timestamps'
], (_, Backbone, I18n, Base, Timestamps) ->

  class User extends Base.Model
    @use(Timestamps)

    # user getter methods
    getName: -> @get('name')
    getFullname: -> @get('fullname')
    getAvatarUrl: -> @get('avatar_url')
    getAvatarMiniUrl: -> @get('avatar_mini_url')
