Backbone.CompositeForm = (options) ->
  Backbone.Form.apply(@, [options])

_.extend Backbone.CompositeForm.prototype, Backbone.Form.prototype,

  leave: () ->
    @unbind()
    @remove()
    @parent._removeChild(@)

Backbone.CompositeForm.extend = Backbone.Form.extend
