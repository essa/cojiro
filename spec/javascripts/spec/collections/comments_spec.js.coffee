define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')
  Comment = require('models/comment')
  Comments = require('collections/comments')

  Thread = require('models/thread')
  Threads = require('collections/threads')

  describe 'Comments', ->

    it 'can be instantiated', ->
      collection = new Comments
      expect(Comments).not.toBeNull()

    it 'contains instances of Comment', ->
      collection = new Comments
      expect(collection.model).toEqual(Comment)

    describe 'when instantiated with model literal', ->
      beforeEach ->
        @comments = new Comments
        @comments.add(id: 12, text: 'a comment text')

      it 'adds a new model', ->
        expect(@comments.length).toEqual(1)

      it 'finds a model by id', ->
        expect(@comments.get(12).get('id')).toEqual(12)

    describe '#url', ->

      describe 'with no thread set', ->
        beforeEach -> @comments = new Comments

        it 'throws error', ->
          self = @
          expect(-> self.comments.url()).toThrow('thread required')

      describe 'with no threads collection', ->
        beforeEach ->
          @comments = new Comments
          @comments.thread = new Thread

        it 'throws error', ->
          self = @
          expect(-> self.comments.url()).toThrow('threads collection required')

      describe 'with thread and thread collection set', ->
        beforeEach ->
          thread = new Thread
          thread.collection = new Threads
          thread.id = '123'
          @comments = thread.get('comments')

        it 'is persisted at /en/threads/<thread id>/comments for an English locale', ->
          I18n.locale = 'en'
          expect(@comments.url()).toEqual('/en/threads/123/comments')

        it 'is persisted at /ja/threads/<thread id>/comments for a Japanese locale', ->
          I18n.locale = 'ja'
          expect(@comments.url()).toEqual('/ja/threads/123/comments')
