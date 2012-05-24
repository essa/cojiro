App.ThreadListItemView = App.Views.ThreadListItem = Backbone.View.extend
  tagName: 'tr'

  initialize: ->

  render: ->
    @$el.html(JST['threads/list_item']( model: @model ))
    @
