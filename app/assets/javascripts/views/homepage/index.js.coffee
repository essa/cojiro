App.HomepageView = App.Views.Homepage = Backbone.View.extend
  id: 'homepage'

  initialize: ->
    _.bindAll @
    @render()

  render: ->
    @$el.html(JST['homepage/index'])
    threadListView = new App.ThreadListView(collection: @collection)
    @.$('#threads').html(threadListView.render().el)
    @
