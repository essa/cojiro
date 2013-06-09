define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  AddLinkModalView = require('views/threads/add_link_modal')

  router = navigate: ->

  describe "AddLinkModalView", ->
    beforeEach ->
      I18n.locale = 'en'
      @submitURLSpy = sinon.spy(AddLinkModalView.prototype, 'submitURL')

    afterEach ->
      AddLinkModalView.prototype.submitURL.restore()

    describe 'with no Link model', ->
      describe "rendering", ->
        beforeEach ->
          @view = new AddLinkModalView

        afterEach ->
          I18n.locale = I18n.defaultLocale

        it "returns the view object", ->
          expect(@view.render()).toEqual(@view)

        it "renders URL input form", ->
          $el = @view.render().$el
          expect($el.find('.modal-header')).toHaveText(/Add a link/)
          expect($el.find('.modal-body')).toContain('form:contains("URL")')

    describe 'with actual Link modal', ->
      beforeEach ->
        @model = new Link
        @collection = new Backbone.Collection([], model: Link, url: '/collection')
        @model.collection = @collection
        @view = new AddLinkModalView(model: @model, collection: @collection, router: router)

      describe 'submitting url form', ->
        beforeEach ->
          @view.render()
          @$form = @view.$('form')
          sinon.stub(@model, 'save')

        it 'calls submitURL', ->
          @$form.submit()
          expect(@submitURLSpy).toHaveBeenCalledOnce()

        it 'prevents default form submission', ->
          spyEvent = spyOnEvent(@$form, 'submit')
          @$form.submit()
          expect('submit').toHaveBeenPreventedOn(@$form)
          expect(spyEvent).toHaveBeenPrevented()

        it 'sets the url', ->
          @view.$('form input').val('http://www.example.com')
          @$form.submit()
          expect(@model.get('url')).toEqual('http://www.example.com')

        it 'saves the link', ->
          sinon.stub(@model, 'set')
          @$form.submit()
          expect(@model.save).toHaveBeenCalledOnce()
          @model.set.restore()

      describe 'with errors', ->
        xit 'renders errors', ->

      describe 'after saving link with URL', ->
        beforeEach ->
          @view.render()
          @server = sinon.fakeServer.create()
          @server.respondWith(
            'POST'
            '/collection'
            @validResponse(id: '123')
          )
          @view.$('form input').val('http://www.example.com')

        afterEach ->
          @server.restore()

        it 'renders step 2 template', ->
