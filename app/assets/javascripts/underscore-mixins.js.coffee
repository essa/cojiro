define ['underscore'], (_) ->
  _.mixin
    capitalize: (str) ->
      return str.charAt(0).toUpperCase() + str.substring(1).toLowerCase()
