define (require) ->

  Comment = require('models/comment')
  Comments = require('collections/comments')
  Thread = require('models/thread')
  Threads = require('collections/threads')
  Link = require('models/link')

  describe 'Comment', ->

    it 'can be instantiated', ->
      comment = new Comment
      expect(comment).not.toBeNull()


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

    describe 'interacting with the server', ->
      beforeEach ->
        @link = new Link(url: 'http://www.example.com', id: 456)
        @collection = new Threads
        @thread = new Thread(id: 123)
        @thread.collection = @collection
        @comment = new Comment(thread: 123, link: 'http://www.example.com')
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
            text: 'a comment text'
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)

          expect(params.comment).toBeDefined()
          expect(params.comment.text).toEqual('a comment text')
          expect(params.comment.link_id).toEqual(456)

        it 'does not leak other data in server request', ->
          @comment.save()
          request = @server.requests[0]
          params = JSON.parse(request.requestBody)
          delete(params.comment.link_id)
          expect(params).toEqual(comment: {})
