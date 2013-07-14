define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
], ($, _, Backbone, BaseView) ->

  class ConfirmLinkDetailsView extends BaseView
    className: 'form'
    template: _.template '
      <form>
      </form>
    '

    render: () ->
      @$el.html(@template())
      @
