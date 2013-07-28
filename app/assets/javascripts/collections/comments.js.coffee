define [
  'backbone'
  'models/comment'
], (Backbone, Comment) ->

  class Comments extends Backbone.Collection
    model: Comment
