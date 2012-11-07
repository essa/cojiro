define [
  'globals'
], (globals) ->
  return {
    currentUser: globals.current_user
    isLoggedIn: globals.current_user
  }
