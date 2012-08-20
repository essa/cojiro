class App.ThreadListItemView extends Support.CompositeView
  tagName: 'tr'
  id: 'thread-list-item'

  initialize: ->

  render: ->
    @$el.html(JST['threads/list_item']( model: @model ))
    @

App.Views.ThreadListItem = App.ThreadListItemView
