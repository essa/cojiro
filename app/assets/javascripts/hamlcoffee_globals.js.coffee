define [
  'globals',
  'hamlcoffee'
], (globals) ->
  HAML.globals = ->
    currentUser: globals.current_user
    isLoggedIn: globals.current_user?
