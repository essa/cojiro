define [
  'jquery',
  'underscore',
  'backbone'
], ($, _, Backbone) ->
  
  class BaseModel extends Backbone.Model

    validate: (attrs) -> {}
