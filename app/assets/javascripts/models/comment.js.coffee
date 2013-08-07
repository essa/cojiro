define [
  'modules/base/model'
  'modules/extended/timestamps'
  'models/user'
], (BaseModel, Timestamps, User) ->

  class Comment extends BaseModel
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

    validate: (attrs) ->
      errors = super(attrs) || {}
      return !_.isEmpty(errors) && errors

    getId: -> @id
    getText: -> @get('text')

    toJSON: () ->
      delete((json = super).user_name)
      json

  # http://backbonerelational.org/#RelationalModel-setup
  Comment.setup()
