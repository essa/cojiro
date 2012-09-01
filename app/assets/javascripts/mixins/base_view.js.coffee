# ref: http://fiznool.com/post/29347337512/backbone-js-view-inheritance
class App.BaseView extends Support.CompositeView

  buildEvents: () -> {}
  initialize: (options) -> @delegateEvents(@buildEvents())
