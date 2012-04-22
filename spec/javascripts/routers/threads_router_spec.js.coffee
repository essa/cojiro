describe 'CojiroApp.Routers.Threads', ->
  beforeEach ->
    @router = new CojiroApp.Routers.Threads()
    @spy = sinon.spy()
    try
      Backbone.history.start
        silent: true,
        pushState: false
    catch e
    @router.navigate "elsewhere"

  it "fires the show route with a blank hash", ->
    @router.bind "route:show", @spy
    @router.navigate "", true
    expect(@spy).toHaveBeenCalledOnce()
    expect(@spy).toHaveBeenCalledWith()
