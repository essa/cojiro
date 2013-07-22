define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'i18n'
], ($, _, Backbone, BaseView, I18n) ->

  class Form extends BaseView
    tagName: 'form'
    className: 'form-horizontal'
    wildcard: 'xx'

    options:
      template:
        _.template '
          <fieldset>
            <% _.each(items, function(item) { %>
              <% if (item.translated == true) { %>
                <% _.each(item.html, function(html, locale) { %>
                  <div class="control-group">
                    <label class="control-label" for="<%= item.cid %>-<%= item.key %>-<%= locale %>">
                        <%= _(item.label).isFunction() ? item.label(locale) : item.label %>
                    </label>
                    <div class="controls">
                      <%= html %>
                      <div class="help-block"></div>
                    </div>
                  </div>
                <% }); %>
              <% } else { %>
                <div class="control-group">
                  <label class="control-label" for="<%= item.cid %>-<%= item.key %>">
                    <%= item.label %>
                  </label>
                  <div class="controls">
                    <%= item.html %>
                    <div class="help-block"></div>
                  </div>
                </div>
              <% }; %>
            <% }); %>
          </fieldset>
        '

    initialize: (options = {}) ->
      if !@model
        throw new Error('Translatable.Form needs a model to work with.')
      if !(@model instanceof Backbone.Model)
        throw new Error("Translatable.Form's model must be a Backbone.Model.")
      if !(@model.schema)
        throw new Error("Translatable.Form's model must have a schema.")
      @schema = -> _(@model).result('schema')
      if (@locales = @options.locales) && !(@locales instanceof Array)
        throw new Error("Translatable.Form's locales must be an array of locale strings.")
      @wildcard = options.wildcard if options.wildcard

    render: ->
      @$el.html(@html())
      @

    html: ->
      @options.template(items: @getItems())

    sourceLocale: -> I18n.locale

    getItems: ->
      self = @
      schema = @schema()
      translatableAttributes = @model.translatableAttributes
      keys = _(schema).keys()
      locales = @locales || [ self.wildcard ]

      _(keys).map (key) ->
        type = schema[key]['type']
        label = schema[key]['label'] || key
        value = self.model.get(key)

        if translated = translatableAttributes && (key in translatableAttributes)
          value = value.toJSON()
          html = {}
          _(locales).each (locale) ->
            html[locale] = self.getHtml(key, value[locale] || '', type, locale)
        else
          html = self.getHtml(key, value, type)
        {
          html: html
          label: label
          key: key
          translated: translated
          cid: self.cid
        }

    getHtml: (key, value, type, lang = "") ->
      key = (key + '-' + lang) if lang
      pattern = switch(type)
        when 'Text'
          '<div class="input-xlarge">
            <input id=":cid-:key" name=":key" size="30" type="text" value=":value" :lang/>
           </div>'
        when 'TextArea'
          '<div class="input-xlarge">
            <textarea id=":cid-:key" name=":key" size="30" type="text" value=":value" :lang/>
           </div>'
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
        name = a.name.replace(self.wildcard, self.sourceLocale())
        [attribute, locale] = name.split('-')
        if locale
          o[attribute] ||= {}
          o[attribute][locale] = self.value(a.value)
        else
          o[name] = self.value(a.value)
      return o

    renderError: (msg, attribute, levels = []) =>
      self = @
      levels.push(attribute)
      if _(msg).isObject()
        _(msg).each (value, key) -> self.renderError(msg[key], key, levels)
      else
        name = levels.join('-')
        _([name, name.replace(self.sourceLocale(), self.wildcard)]).each (name) ->
          controlGroup = self.$el.find("[name='#{name}']").closest('.control-group')
          controlGroup.addClass('error')
          controlGroup.find('.help-block').text(msg)

    renderErrors: (errors) ->
      self = @
      _(errors).each (msg, attribute) -> self.renderError(msg, attribute)

    value: (val) ->
      switch(val)
        when 'true' then true
        when 'false' then false
        when 'null' then null
        else val
