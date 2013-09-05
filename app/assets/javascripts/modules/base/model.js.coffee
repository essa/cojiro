define [
  'jquery'
  'underscore'
  'backbone'
], ($, _, Backbone) ->

  class BaseModel extends Backbone.RelationalModel

    getId: -> @id

    @use: (classes...) ->
      for cl in classes
        for key, value of cl::
          @::[key]=value
      @
