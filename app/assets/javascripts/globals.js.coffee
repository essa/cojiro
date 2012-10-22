# http://stackoverflow.com/questions/9916073/how-to-load-bootstrapped-models-in-backbone-js-while-using-amd-require-js/10288587#10288587
define [
  'config',
  'underscore'
], (config, _) ->
  globals = {}
  _.extend(globals, config)
