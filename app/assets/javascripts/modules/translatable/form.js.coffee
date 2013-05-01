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
        label = schema[key]['title'] || key
        value = self.model.get(key)
        {
          type: type
          html: self.getHtml(key, value, type)
          label: label
          value: value
          cid: self.cid
        }

     getHtml: (key, value, type) ->
       pattern = switch(type)
         when 'Text'
           '<input class="xlarge" id="input-:cid-:label" name="input-:cid-:label" size="30" type="text" value=":value" />'
         when 'TextArea'
           '<textarea class="xlarge" id="input-:cid-:label" name="input-:cid-:label" size="30" type="text" value=":value" />'
       return pattern && pattern
           .replace(/:cid/g, @cid)
           .replace(/:label/g, key)
           .replace(/:value/g, value)

     serialize: =>
       form = if @tagName == 'form' then @$el else @$el.find('form')
       throw new Error('Serialize must operate on a form element.') unless form.length
       cid = @cid
       self = @
       o = {}
       _(form.serializeArray()).each (a, i) ->
         name = a.name.replace('input-' + cid + '-', '')
         o[name] = self.value(a.value)
       return o

     value: (val) ->
       switch(val)
         when 'true' then true
         when 'false' then false
         when 'null' then null
         else val
