define (require) ->

  User = require('models/user')

  describe 'User', ->
    beforeEach ->
      @user = new User

    it 'can be instantiated', ->
      expect(@user).not.toBeNull()

    describe '#getName', ->
      it 'is defined', -> expect(@user.getName).toBeDefined()

      it 'returns name attribute of user associated with user', ->
        stub = sinon.stub(@user, 'get').returns('csasaki')

        expect(@user.getName()).toEqual('csasaki')
        expect(stub).toHaveBeenCalledWith('name')

    describe '#getFullname', ->
      it 'is defined', -> expect(@user.getFullname).toBeDefined()

      it 'returns fullname attribute of user associated with user', ->
        stub = sinon.stub(@user, 'get').returns('Cojiro Sasaki')

        expect(@user.getFullname()).toEqual('Cojiro Sasaki')
        expect(stub).toHaveBeenCalledWith('fullname')

    describe '#getAvatarUrl', ->
      it 'is defined', -> expect(@user.getAvatarUrl).toBeDefined()

      it 'returns URL of original version of user avatar associated with user', ->
        stub = sinon.stub(@user, 'get').returns('http://www.example.com/csasaki.png')

        expect(@user.getAvatarUrl()).toEqual('http://www.example.com/csasaki.png')
        expect(stub).toHaveBeenCalledWith('avatar_url')

    describe '#getAvatarMiniUrl', ->
      it 'is defined', -> expect(@user.getAvatarMiniUrl).toBeDefined()

      it 'returns URL of mini version of user avatar associated with user', ->
        stub = sinon.stub(@user, 'get').returns('http://www.example.com/mini_csasaki.png')

        expect(@user.getAvatarMiniUrl()).toEqual('http://www.example.com/mini_csasaki.png')
        expect(stub).toHaveBeenCalledWith('avatar_mini_url')
