define [
  'globals'
], (globals) ->
  return {
    currentUser: globals.currentUser
    isLoggedIn: globals.currentUser?
  }
