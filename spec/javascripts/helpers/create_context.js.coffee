# http://stackoverflow.com/questions/11439540/how-can-i-mock-dependencies-for-unit-testing-in-requirejs
window.context = (stubs) ->
  
  map = {}

  _.each stubs, (value, key) ->
    stubname = 'stub' + key
    map[key] = stubname

  # copy over whatever global map existed in cfg
  _.each cfg['map']['*'], (value, key) ->
    map[key] ||= value

  options =
    context: Math.floor(Math.random() * 1000000),
  _.extend(options, cfg)

  options['map'] = _.clone cfg['map']
  options['map']['*'] = map

  context = require.config(options)

  _.each stubs, (value, key) ->
    stubname = 'stub' + key
    define(stubname, () -> value)

  return context
