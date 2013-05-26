define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')

  model = new Backbone.Model(id: 5, text: "a comment text")
  Comment = sinon.stub().returns(model)

  context(
    'models/comment': Comment
  ) ['collections/comments'], (Comments) ->

    describe 'Comments (with stubbed Comment model)', ->

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

        xit 'finds a model by id', ->
          expect(@comments.get(12).get('id')).toEqual(12)

      describe '#url', ->
        beforeEach -> @comments = new Comments

        it 'is persisted at /en/comments for an English locale', ->
          I18n.locale = 'en'
          expect(@comments.url()).toEqual('/en/comments')

        it 'is persisted at /ja/comments for a Japanese locale', ->
          I18n.locale = 'ja'
          expect(@comments.url()).toEqual('/ja/comments')
