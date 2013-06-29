define [
  'jquery',
  'underscore',
  'backbone',
  'models/link'
  'modules/base/view',
  'modules/translatable',
  'globals',
  'templates/links/show'
], ($, _, Backbone, Link, BaseView, Translatable, globals, showLinkTemplate) ->

  class LinkView extends BaseView
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
