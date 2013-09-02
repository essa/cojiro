define (require) ->

  _ = require 'underscore'
  BaseView = require 'modules/base/view'
  require 'bootstrap'

  class ModalView extends BaseView
    el: '#modal'
    template: _.template '
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header"></div>
            <div class="modal-body"></div>
            <div class="modal-footer"></div>
          </div>
        </div>'

    buildEvents: () ->
      _(super).extend
        'click button.close': 'hideModal'

    initialize: (options = {}) ->
      super(options)

      @on('show', @showModal)
      @on('hide', @hideModal)

    showModal: () ->
      @render()
      @$el.modal('show')

    hideModal: () ->
      @$el.modal('hide')
      @reset()
      @$el.empty()

    getClasses: ->
      cl = @$el.attr('class')
      cl && cl.split(' ') || []

    reset: () ->
      classes = @getClasses()
      @$el.attr('class', 'modal hide fade')
      @$el.addClass('in') if 'in' in classes

    # override default to avoid removing element from view
    remove: ->
      @$el.empty()
      @hideModal()
      @unbind()
      @stopListening()
      @
