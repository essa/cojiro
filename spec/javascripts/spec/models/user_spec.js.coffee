define (require) ->

  User = require('models/user')

  describe 'User', ->

    it 'can be instantiated', ->
      user = new User
      expect(user).not.toBeNull()
