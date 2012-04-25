describe 'App.Routers.AppRouter', ->
  beforeEach ->
    @router = new App.Routers.AppRouter()
    @spy = sinon.spy()
    try
      Backbone.history.start
        silent: true,
        pushState: false
    catch e
    @router.navigate "elsewhere"

  it "fires the index route with a blank hash", ->
    @router.bind "route:index", @spy
    @router.navigate "", true
    expect(@spy).toHaveBeenCalledOnce()
    expect(@spy).toHaveBeenCalledWith()
