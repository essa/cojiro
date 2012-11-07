define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/translatable_fields_view',
  'globals',
  'templates/threads/show',
  'templates/other/flash'
], ($, _, Backbone, TranslatableFieldsView, globals, showThreadTemplate, flashTemplate) ->

  class ThreadView extends TranslatableFieldsView
    id: 'thread'

    initialize: ->
      super

    render: ->
      @$el.html(showThreadTemplate(model: @model))
      if globals.flash?
        @$el.prepend(flashTemplate(globals.flash))
        globals.flash = null
      @
