define (require) ->

  Comment = require('models/comment')

  describe 'Comment', ->

    it 'can be instantiated', ->
      comment = new Comment
      expect(comment).not.toBeNull()
