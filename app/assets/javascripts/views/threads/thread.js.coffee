define [
  'jquery',
  'underscore',
  'backbone',
  'modules/translatable',
  'globals',
  'templates/threads/show',
  'templates/other/flash'
], ($, _, Backbone, Translatable, globals, showThreadTemplate, flashTemplate) ->

  class ThreadView extends Translatable.View
    id: 'thread'

    initialize: ->
      super

    render: ->
      @$el.html(showThreadTemplate(model: @model))
      if globals.flash?
        @$el.prepend(flashTemplate(globals.flash))
        globals.flash = null
      @
