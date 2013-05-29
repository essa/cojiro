define [
  'modules/base'
  'modules/extended/timestamps'
], (Base, Timestamps) ->

  class Comment extends Base.Model
    @use Timestamps
