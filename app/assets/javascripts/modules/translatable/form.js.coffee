define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'i18n'
], ($, _, Backbone, Base, I18n) ->

  class Form extends Base.View
    tagName: 'form'

    options:
      template:
        _.template([
          '<% _.each(items, function(item) { %>',
          ' <div class="clearfix">',
          '   <label for="input-<%= item.cid %>-<%= item.label %>"><%= item.label %></label>',
          '   <div class="input">',
          '     <%= item.html %>',
          '   </div>',
          ' </div>',
          '<% }); %>'
        ].join('\n'))

    initialize: ->
      if !@model
        throw new Error('Translatable.Form needs a model to work with.')
      if !(@model instanceof Backbone.Model)
        throw new Error("Translatable.Form's model must be a Backbone.Model.")
      if !(@model.schema)
        throw new Error("Translatable.Form's model must have a schema.")
      if !(@model.schema instanceof Function)
        throw new Error("Translatable.Form's model schema must be a function.")

    render: ->
      @$el.html(@html())
      @

    html: ->
      @options.template(items: @getItems())

    getItems: ->
      self = @
      schema = @model.schema()
      keys = _(schema).keys()

      _(keys).map (key) ->
        type = schema[key]['type']
        value = self.model.get(key)
        {
          type: type
          html: self.getHtml(key, value, type)
          label: key
          value: value
          cid: self.cid
        }

     getHtml: ->
