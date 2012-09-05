class App.NavbarView extends App.BaseView
  className: 'navbar navbar-fixed-top'

  initialize: ->

  render: ->
    @$el.html(JST['other/navbar'])
    @

App.Views.Navbar = App.NavbarView
