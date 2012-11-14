# http://stackoverflow.com/questions/11439540/how-can-i-mock-dependencies-for-unit-testing-in-requirejs
window.context = (stubs) ->
  
  map = {}

  # force modules to use same jQuery object
  stubs = _.extend(stubs, "jquery": jQuery)

  _.each stubs, (value, key) ->
    map[key] = 'stub' + key

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
    define('stub' + key, () -> value)

  return context
