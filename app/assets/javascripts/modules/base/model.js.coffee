define [
  'jquery'
  'underscore'
  'backbone'
], ($, _, Backbone) ->

  class BaseModel extends Backbone.RelationalModel

    getId: -> @id
    validate: (attrs) -> {}

    @use: (classes...) ->
      for cl in classes
        for key, value of cl::
          @::[key]=value
      @
