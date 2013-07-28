define [
  'modules/base/model'
  'modules/extended/timestamps'
], (BaseModel, Timestamps) ->

  class Comment extends BaseModel
    urlRoot: ->
      throw('thread required') unless thread = @get('thread')
      thread.url() + '/comments'
    @use Timestamps

    validate: (attrs) ->
      errors = super(attrs) || {}
      return !_.isEmpty(errors) && errors

    toJSON: () ->
      json = _.clone(super)
      json['link_id'] = json['link']
      delete(json['thread'])
      delete(json['link'])
      comment: json

  # http://backbonerelational.org/#RelationalModel-setup
  Comment.setup()
