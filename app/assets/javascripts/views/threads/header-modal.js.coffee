define [
  'underscore'
  'modules/base/view'
], (_, BaseView) ->

  class ThreadHeaderModal extends BaseView
    template: _.template ''
    className: 'thread-header-modal'

    render: -> @$el.html(@template())
