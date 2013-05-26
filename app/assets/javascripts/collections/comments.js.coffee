define [
  'backbone'
  'models/comment'
], (Backbone, Comment) ->

  class Comments extends Backbone.Collection
    model: Comment
    url: -> '/' + I18n.locale + '/comments'
