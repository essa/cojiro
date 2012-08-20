class App.NavbarView extends Support.CompositeView
  className: 'navbar navbar-fixed-top'

  initialize: ->

  render: ->
    @$el.html(JST['other/navbar'])
    @

App.Views.Navbar = App.NavbarView
