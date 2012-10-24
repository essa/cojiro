# http://stackoverflow.com/questions/11439540/how-can-i-mock-dependencies-for-unit-testing-in-requirejs
window.createContext = (stubs) ->

  map = {}

  _.each stubs, (value, key) ->
    stubname = 'stub' + key
    map[key] = stubname

  options =
    context: Math.floor(Math.random() * 1000000),
    map:
      "*": map
  _.extend(options, cfg)

  context = require.config(options)

  _.each stubs, (value, key) ->
    stubname = 'stub' + key
    define(stubname, () -> value)

  return context
