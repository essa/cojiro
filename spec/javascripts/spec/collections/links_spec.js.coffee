define (require) ->

  Backbone = require('backbone')

  model = new Backbone.Model(id: 7, title: 'a link')
  Link = sinon.stub().returns(model)

  context(
    'models/link': Link
  ) ['collections/links'], (Links) ->

    describe 'Links (with stubbed Link model)', ->

      it 'can be instantiated', ->
        collection = new Links()
        expect(Links).not.toBeNull()

      it 'contains instances of Link', ->
        collection = new Links()
        expect(collection.model).toEqual(Link)
