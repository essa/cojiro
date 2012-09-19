define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/translatable_fields_view'
], ($, _, Backbone, TranslatableFieldsView) ->

  class ThreadView extends TranslatableFieldsView
    id: 'thread'

    initialize: ->
      super

    render: ->
      @$el.html(JST['threads/show'](model: @model))
      if App.flash?
        @$el.prepend(JST['other/flash'](App.flash))
        App.flash = null
      @
