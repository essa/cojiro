define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/translatable_fields_view',
  'globals',
  'templates/threads/show',
  'templates/other/flash'
], ($, _, Backbone, TranslatableFieldsView, globals) ->

  class ThreadView extends TranslatableFieldsView
    id: 'thread'

    initialize: ->
      super

    render: ->
      @$el.html(JST['threads/show'](model: @model))
      if globals.flash?
        @$el.prepend(JST['other/flash'](globals.flash))
        globals.flash = null
      @
