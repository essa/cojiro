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
                  <div class="form-group <%= item.key %>">
                    <label class="control-label col-xs-2" for="<%= item.cid %>-<%= item.key %>-<%= locale %>">
                        <%= _(item.label).isFunction() ? item.label(locale) : item.label %>
                    </label>
                    <div class="col-xs-10">
                      <% if ((sourceValue = item.sourceValue) && (item.sourceLocale != locale)) { %>
                        <div class="help-block source-value"><%= sourceValue %></div>
                      <% } %>
                      <%= html %>
                      <div class="help-block"></div>
                    </div>
                  </div>
                <% }); %>
              <% } else { %>
                <div class="form-group <%= item.key %>">
                  <label class="control-label col-xs-2" for="<%= item.cid %>-<%= item.key %>">
                    <%= item.label %>
                  </label>
                  <div class="col-xs-10">
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
      locales = @locales

      _(keys).map (key) ->
        type = schema[key]['type']
        if locales then label = schema[key]['label']
        else label = _(schema[key]).result('label')
        label ||= key
        value = self.model.get(key)
        values = schema[key]['values']

        if translated = translatableAttributes && (key in translatableAttributes)
          value = value.toJSON()
          sourceValue = self.model.getAttrInSourceLocale(key)
          sourceLocale = self.model.getSourceLocale()
          html = {}
          _(locales || [ I18n.locale ]).each (locale) ->
            options = locale: locale, sourceLocale: sourceLocale
            _(options).extend(values: values) if values?
            html[locale] = self.getHtml(key, value[locale] || '', type, options)
        else
          options = values: values if values?
          html = self.getHtml(key, value, type, options)
        _(translated? && (sourceLocale: sourceLocale, sourceValue: sourceValue)).extend
          html: html
          label: label
          key: key
          translated: translated
          cid: self.cid

    getHtml: (key, value, type, options = {}) ->
      key = (key + '-' + options.locale) if options.locale
      locale = options.locale || ''
      sourceLocale = options.sourceLocale || ''
      pattern = switch(type)
        when 'Text'
          '<input class="form-control" id=":cid-:key" name=":key" type="text" value=":value":placeholder:lang/>'
        when 'TextArea'
          '<textarea class="form-control" id=":cid-:key" name=":key" type="text" rows="3":placeholder:lang>:value</textarea>'
        when 'Select'
          fragment = ['<select class="form-control" id=":cid-:key" name=":key">']
          fragment = fragment.concat(_(options.values || {}).map (displayVal, val) ->
            selected = if (value == val) then ' selected="selected"' else ''
            '<option value="' + val + '"' + selected + '>' + displayVal + '</option>')
          fragment.push('</select>')
          fragment.join('')
      placeholder = ''
      if locale && sourceLocale && (locale != sourceLocale)
        placeholder = I18n.t('modules.translatable.field-form.translate_to_lang', lang: I18n.t(locale))
      pattern && pattern
          .replace(/:cid/g, @cid)
          .replace(/:key/g, key)
          .replace(/:value/g, value || "")
          .replace(/:lang/g, locale && (' lang="' + locale + '"'))
          .replace(/:placeholder/g, placeholder && (' placeholder="' + placeholder + '"'))

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
        formGroup = self.$el.find("[name='#{name}']").closest('.form-group')
        formGroup.addClass('has-error')
        formGroup.find('.help-block').text(msg)

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
      _(@schema()).each (attrSchema, key) ->
        id = "#{view.cid}-#{key}-#{prevLocale}"
        newId = "#{view.cid}-#{key}-#{locale}"
        label = view.$("label.control-label[for='#{id}']")
        if _.isFunction(attrSchema.label)
          label.text(attrSchema.label(locale))
        label.attr('for', newId)
        view.$('#' + id)
          .attr('name', key + '-' + locale)
          .attr('id', newId)
          .attr('lang', locale)
