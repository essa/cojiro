class App.ThreadFilterView extends App.BaseView
  className: 'commentheader form-horizontal'
  tagName: 'form'
  id: 'thread-filter'

  buildEvents: () ->
    _(super).extend
      "change select": "selectFilter"

  render: =>
    @$el.html(JST['homepage/thread_filter'])
    @

  selectFilter: (e) =>
    val = $(e.currentTarget).val()
    @trigger("changed", val)

App.Views.ThreadFilter = App.ThreadFilterView
