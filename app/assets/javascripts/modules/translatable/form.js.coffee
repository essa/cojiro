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

    options:
      template:
        _.template '
          <fieldset>
            <% _.each(items, function(item) { %>
              <% if (item.translated == true) { %>
                <% _.each(item.html, function(html, locale) { %>
                  <div class="control-group <%= item.key %>">
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
      self = @
      @model.on('invalid', (model, error) -> self.renderErrors(error))
      @on('changeLocale', @changeLocale)

    render: ->
      @$el.html(@html())
      @

    html: ->
      @options.template(items: @getItems())

    getItems: ->
      self = @
      schema = @schema()
      translatableAttributes = @model.translatableAttributes
      keys = _(schema).keys()
      locales = @locales || [ I18n.locale ]

      _(keys).map (key) ->
        type = schema[key]['type']
        label = schema[key]['label'] || key
        value = self.model.get(key)
        values = schema[key]['values']

        if translated = translatableAttributes && (key in translatableAttributes)
          value = value.toJSON()
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
        name = a.name
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

    changeLocale: (locale) ->
      return if @locales && @locales.length > 1
      return unless locale in I18n.availableLocales
      prevLocale = @locales && @locales[0] || I18n.locale
      @locales = [ locale ]
      view = @
      _.chain(@schema()).keys().each (key) ->
        id = "#{view.cid}-#{key}-#{prevLocale}"
        newId = "#{view.cid}-#{key}-#{locale}"
        view.$("label.control-label[for='#{id}']").attr('for', newId)
        view.$('#' + id)
          .attr('name', key + '-' + locale)
          .attr('id', newId)
          .attr('lang', locale)
