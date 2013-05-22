define [
  'backbone'
  'models/link'
], (Backbone, Link) ->

  class Links extends Backbone.Collection
    model: Link
