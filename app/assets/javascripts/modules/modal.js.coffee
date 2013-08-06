define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'bootstrap-modal'
], ($, _, Backbone, BaseView) ->

  class ModalView extends BaseView
    el: '#modal'

    buildEvents: () ->
      _(super).extend
        'click button.close': 'hideModal'

    initialize: (options = {}) ->
      super(options)

      @on('view:show', @showModal)

    showModal: () ->
      @render()
      @$el.modal('show')

    hideModal: () ->
      @$el.modal('hide')

    # override default to avoid removing element from view
    remove: ->
      @$el.empty()
      @stopListening()
      @
