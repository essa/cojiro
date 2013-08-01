define [
  'modules/base/model'
  'modules/extended/timestamps'
], (BaseModel, Timestamps) ->

  class Comment extends BaseModel
    @use Timestamps
    name: 'comment'

    urlRoot: ->
      throw('thread required') unless thread = @get('thread')
      thread.url() + '/comments'

    validate: (attrs) ->
      errors = super(attrs) || {}
      return !_.isEmpty(errors) && errors

    getId: -> @id

  # http://backbonerelational.org/#RelationalModel-setup
  Comment.setup()
