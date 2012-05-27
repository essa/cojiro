App.ThreadListItemView = App.Views.ThreadListItem = Backbone.View.extend
  tagName: 'tr'
  id: 'thread-list-item'

  initialize: ->

  render: ->
    @$el.html(JST['threads/list_item']( model: @model ))
    @
