define [
  'jquery'
  'backbone'
], ($, Backbone) ->
  
  class BaseModel extends Backbone.Model

    validate: (attrs) -> {}
