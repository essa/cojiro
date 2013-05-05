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
        _.template '
          <% _.each(items, function(item) { %>
            <div class="clearfix">
              <% if (item.translated == true) { %>
                <% _.each(item.html, function(html, locale) { %>
                  <div class="input">
                    <label>
                      <%= locale %>
                    </label>
                    <%= html %>
                  </div>
                <% }); %>
              <% } else { %>
                <label for="input-<%= item.cid %>-<%= item.label %>">
                  <%= item.label %>
                </label>
                <div class="input">
                  <%= item.html %>
                </div>
              <% }; %>
            </div>
          <% }); %>
        '

    initialize: ->
      if !@model
        throw new Error('Translatable.Form needs a model to work with.')
      if !(@model instanceof Backbone.Model)
        throw new Error("Translatable.Form's model must be a Backbone.Model.")
      if !(@model.schema)
        throw new Error("Translatable.Form's model must have a schema.")
      if !(@model.schema instanceof Function)
        throw new Error("Translatable.Form's model schema must be a function.")
      if (@locales = @options.locales) && !(@locales instanceof Array)
        throw new Error("Translatable.Form's locales must be an array of locale strings.")

    render: ->
      @$el.html(@html())
      @

    html: ->
      @options.template(items: @getItems())

    getItems: ->
      self = @
      schema = @model.schema()
      translatableAttributes = @model.translatableAttributes
      keys = _(schema).keys()
      locales = @locales || [I18n.locale]

      _(keys).map (key) ->
        type = schema[key]['type']
        label = schema[key]['title'] || key
        value = self.model.get(key)

        if translated = translatableAttributes && (key in translatableAttributes)
          value = value.toJSON()
          html = {}
          _(locales).each (locale) ->
            html[locale] = self.getHtml(key, value[locale], type, locale)
        else
          html = self.getHtml(key, value, type)
        {
          html: html
          label: label
          translated: translated
          cid: self.cid
        }

     getHtml: (key, value, type, lang = "") ->
       key = (key + '-' + lang) if lang
       pattern = switch(type)
         when 'Text'
           '<input class="xlarge" id="input-:cid-:key" name="input-:cid-:key" size="30" type="text" value=":value" :lang/>'
         when 'TextArea'
           '<textarea class="xlarge" id="input-:cid-:key" name="input-:cid-:key" size="30" type="text" value=":value" :lang/>'
       return pattern && pattern
           .replace(/:cid/g, @cid)
           .replace(/:key/g, key)
           .replace(/:value/g, value || "")
           .replace(/:lang/g, lang && ('lang="' + lang + '"'))

     serialize: =>
       form = if @tagName == 'form' then @$el else @$el.find('form')
       throw new Error('Serialize must operate on a form element.') unless form.length
       cid = @cid
       self = @
       o = {}
       _(form.serializeArray()).each (a, i) ->
         name = a.name.replace('input-' + cid + '-', '')
         [attribute, locale] = name.split('-')
         if locale
           o[attribute] ||= {}
           o[attribute][locale] = self.value(a.value)
         else
           o[name] = self.value(a.value)
       return o

     value: (val) ->
       switch(val)
         when 'true' then true
         when 'false' then false
         when 'null' then null
         else val
