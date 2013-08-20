define [
  'backbone'
  'modules/translatable/model'
  'modules/extended/timestamps'
  'models/user'
  'models/link'
], (Backbone, TranslatableModel, Timestamps, User, Link) ->

  class Comment extends TranslatableModel
    @use Timestamps
    name: 'comment'

    urlRoot: ->
      throw('thread required') unless thread = @get('thread')
      thread.url() + '/comments'

    relations: [
        type: Backbone.HasOne
        key: 'user'
        keySource: 'user_name'
        relatedModel: User
        reverseRelation:
          key: 'comments'
          includeInJSON: 'name'
    ]

    translatableAttributes:
      [ 'text' ]

    schema: ->
      text:
        type: 'TextArea'
        label: 'Comment'

    getId: -> @id
    getText: -> @getAttr('text')
    getLink: -> @get('link')
    getThread: -> @get('thread')
    getUser: -> @get('user')
    getUserName: -> @getUser() && @getUser().getName()
    getUserAvatarUrl: -> @getUser() && @getUser().getAvatarMiniUrl()
    getStatusMessage: ->
      if @getUser()
        created_at = @get('created_at') || new Date().toJSON()
        I18n.t('models.comment.added_ago',
          name: @getUserName()
          datetime: created_at
          timeago: $.timeago(created_at)
        )
      else
        ''

    toJSON: () ->
      delete((json = super).user_name)
      json

  # http://backbonerelational.org/#RelationalModel-setup
  Comment.setup()
