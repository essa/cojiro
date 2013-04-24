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

    render: ->
      @$el.html(@html())
      @

    html: ->
