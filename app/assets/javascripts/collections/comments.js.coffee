define [
  'backbone'
], (Backbone) ->

  class Comments extends Backbone.Collection
    model: Comment
