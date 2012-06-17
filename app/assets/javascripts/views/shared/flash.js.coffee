App.FlashView = App.Views.Flash = Support.CompositeView.extend
  id: 'flash_error'
  className: 'alert alert-error error'
  attributes:
    'data-dismiss': 'alert'

  initialize: ->
    @$el.html('<a class="close" href="#">×</a>')

  render: ->
    @
