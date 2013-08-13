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
    getUser: -> @get('user')
    getUserName: -> @getUser().getName()

    toJSON: () ->
      delete((json = super).user_name)
      json

  # http://backbonerelational.org/#RelationalModel-setup
  Comment.setup()
