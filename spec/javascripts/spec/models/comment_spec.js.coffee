define (require) ->

  Comment = require('models/comment')

  describe 'Comment', ->

    it 'can be instantiated', ->
      comment = new Comment
      expect(comment).not.toBeNull()

    describe 'getters', ->
      beforeEach ->
        @comment = new Comment
        @comment.collection = url: '/collection'

      describe '#url', ->
        it 'returns collection URL when id is not set', ->
          expect(@comment.url()).toEqual('/collection')

        it 'returns collection URL and id when id is set', ->
          @comment.id = 66
          expect(@comment.url()).toEqual('/collection/66')
