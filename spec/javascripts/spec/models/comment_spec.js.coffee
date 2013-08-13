define (require) ->

  Comment = require('models/comment')
  Comments = require('collections/comments')
  Thread = require('models/thread')
  Threads = require('collections/threads')
  Link = require('models/link')
  User = require('models/user')

  describe 'Comment', ->

    it 'can be instantiated', ->
      comment = new Comment
      expect(comment).not.toBeNull()

    describe '#getId', ->
      it 'returns the id', ->
        comment = new Comment
        comment.id = 123
        expect(comment.getId()).toEqual(123)

    describe '#url', ->

      describe 'with no thread set', ->
        beforeEach -> @comment = new Comment

        it 'throws error', ->
          self = @
          expect(-> self.comment.url()).toThrow('thread required')

      describe 'with thread set', ->
        beforeEach ->
          thread = new Thread
          thread.collection = new Threads
          thread.id = '123'
          sinon.stub(thread.collection, 'url').returns('/collection')
          @comment = new Comment(thread: thread)

        it 'returns <threads URL>/<thread id>/comments when id is not set', ->
          expect(@comment.url()).toEqual('/collection/123/comments')

        it 'returns <threads URL>/<thread id>/comments/<id> when id is set', ->
          @comment.id = 456
          expect(@comment.url()).toEqual('/collection/123/comments/456')

    describe 'getters', ->
      beforeEach ->
        @comment = new Comment

      describe '#getId', ->
        it 'returns the id', ->
          @comment.id = 123
          expect(@comment.getId()).toEqual(123)

      describe '#getText', ->
        it 'returns the text of this comment in this locale', ->
          @comment.set('text', en: 'foo')
          expect(@comment.getText()).toEqual('foo')

      describe '#getUser', ->
        it 'returns the user who created this comment', ->
          @comment.set('user', user = new User)
          expect(@comment.getUser()).toEqual(user)

      describe '#getUserName', ->
        it 'returns the name of the user who created this comment', ->
          @comment.set('user', user = new User(name: 'bar'))
          expect(@comment.getUserName()).toEqual('bar')

    describe 'interacting with the server', ->
      beforeEach ->
        @collection = new Threads
        @thread = new Thread(id: 123)
        @thread.collection = @collection
        @comment = new Comment(thread: @thread)
        @server = sinon.fakeServer.create()
      afterEach -> @server.restore()

      describe 'saving the record', ->

        it 'makes correct request', ->
          @comment.save
            text: 'a comment text'
          expect(@server.requests.length).toEqual(1)
          expect(@server.requests[0]).toBePOST()
          expect(@server.requests[0]).toHaveUrl('/en/threads/123/comments')

        it 'sends valid data to the server', ->
          @comment.save
            text: en: 'a comment text'
            link:
              url: 'http://www.example.com'
              title: en: 'a link title in English'
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)

          expect(params.comment).toBeDefined()
          expect(params.comment.text).toEqual(en: 'a comment text')
          expect(params.comment.link_attributes).toEqual
            url: 'http://www.example.com'
            title: en: 'a link title in English'
            summary: {}
          # user association should not be sent -- it is set
          # server-side from cookie
          expect(params.comment.user_name).not.toBeDefined()

        it 'does not include link data if link not set', ->
          @comment.save()
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)
          expect(params.comment.link_attributes).toBeNull()
