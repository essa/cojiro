define [
  'jquery',
  'underscore',
  'backbone',
  'models/link'
  'modules/base',
  'modules/translatable',
  'globals',
  'templates/links/show'
], ($, _, Backbone, Link, Base, Translatable, globals, showLinkTemplate) ->

  class LinkView extends Base.View
    className: 'link'

    initialize: ->
      @titleField = new Translatable.InPlaceField(model: @model, field: 'title', editable: globals.currentUser?)
      @summaryField = new Translatable.InPlaceField(model: @model, field: 'summary', editable: globals.currentUser?)
      super

    render: ->
      @$el.html(showLinkTemplate(model: @model))
      @renderTranslatableFields()
      @

    renderTranslatableFields: ->
      @titleField.render()
      @$('.title').html(@titleField.el)
      @summaryField.render()
      @$('.summary').html(@summaryField.el)
