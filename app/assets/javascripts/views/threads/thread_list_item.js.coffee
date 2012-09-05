class App.ThreadListItemView extends App.BaseView
  tagName: 'tr'
  id: 'thread-list-item'
  className: 'clickable'

  initialize: ->
    @$el.attr('data-href': @model.url())

  render: ->
    @$el.html(JST['threads/list_item']( model: @model ))
    @

App.Views.ThreadListItem = App.ThreadListItemView
