define [
  'modules/base/model'
  'modules/extended/timestamps'
], (BaseModel, Timestamps) ->

  class Comment extends BaseModel
    @use Timestamps
