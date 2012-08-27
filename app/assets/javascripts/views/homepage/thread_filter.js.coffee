class App.ThreadFilterView extends Support.CompositeView
  className: 'commentheader form-horizontal'
  tagName: 'form'
  id: 'thread-filter'

  events:
    "change select": "selectFilter"

  render: =>
    @$el.html(JST['homepage/thread_filter'])
    @

  selectFilter: (e) =>
    val = $(e.currentTarget).val()
    @trigger("changed", val)

App.Views.ThreadFilter = App.ThreadFilterView
