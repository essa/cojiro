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

    # override default leave to avoid
    # removing #modal element from page
    leave: () ->
      @trigger('leave')
      @unbind()
      @unbindFromAll()
      #@remove()
      @_leaveChildren()
      #@_removeFromParent()
