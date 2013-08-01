define [
  'modules/base/model'
  'modules/extended/timestamps'
], (BaseModel, Timestamps) ->

  class Comment extends BaseModel
    name: 'comment'

    urlRoot: ->
      throw('thread required') unless thread = @get('thread')
      thread.url() + '/comments'
    @use Timestamps

    validate: (attrs) ->
      errors = super(attrs) || {}
      return !_.isEmpty(errors) && errors

  # http://backbonerelational.org/#RelationalModel-setup
  Comment.setup()
