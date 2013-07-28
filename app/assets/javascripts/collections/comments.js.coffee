define [
  'backbone'
  'models/comment'
], (Backbone, Comment) ->

  class Comments extends Backbone.Collection
    model: Comment
    url: ->
      throw('thread required') unless @thread
      throw('threads collection required') unless @thread.collection
      @thread.url() + '/comments'
