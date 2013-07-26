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
                  <div class="control-group <%= item.key %> <%= item.key %>-<%= locale %>">
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
                <div class="control-group <%= item.key %>">
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
      @sourceLocale = options.sourceLocale if options.sourceLocale
      self = @
      @model.on('invalid', (model, error) -> self.renderErrors(error))

    render: ->
      @$el.html(@html())
      @

    html: ->
      @options.template(items: @getItems())

    sourceLocale: -> I18n.locale

    getItems: ->
      self = @
      wildcard = @wildcard
      schema = @schema()
      translatableAttributes = @model.translatableAttributes
      keys = _(schema).keys()
      locales = @locales || [ wildcard ]
      sourceLocale = @sourceLocale()

      _(keys).map (key) ->
        type = schema[key]['type']
        label = schema[key]['label'] || key
        value = self.model.get(key)
        values = schema[key]['values']

        if translated = translatableAttributes && (key in translatableAttributes)
          value = value.toJSON()
          value[wildcard] = value[sourceLocale]
          html = {}
          _(locales).each (locale) ->
            options = locale: locale
            _(options).extend(values: values) if values?
            html[locale] = self.getHtml(key, value[locale] || '', type, options)
        else
          options = values: values if values?
          html = self.getHtml(key, value, type, options)
        {
          html: html
          label: label
          key: key
          translated: translated
          cid: self.cid
        }

    getHtml: (key, value, type, options = {}) ->
      key = (key + '-' + options.locale) if options.locale
      locale = options.locale || ''
      pattern = switch(type)
        when 'Text'
          '<input id=":cid-:key" name=":key" type="text" value=":value":lang/>'
        when 'TextArea'
          '<textarea id=":cid-:key" name=":key" type="text" rows="3":lang>:value</textarea>'
        when 'Select'
          fragment = ['<select id=":cid-:key" name=":key">']
          fragment = fragment.concat(_(options.values || {}).map (displayVal, val) ->
            selected = if (value == val) then ' selected="selected"' else ''
            '<option value="' + val + '"' + selected + '>' + displayVal + '</option>')
          fragment.push('</select>')
          fragment.join('')
      pattern && pattern
          .replace(/:cid/g, @cid)
          .replace(/:key/g, key)
          .replace(/:value/g, value || "")
          .replace(/:lang/g, locale && (' lang="' + locale + '"'))

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
        names = _.uniq([name, name.replace(@sourceLocale(), @wildcard)])
        _(names).each (name) ->
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
