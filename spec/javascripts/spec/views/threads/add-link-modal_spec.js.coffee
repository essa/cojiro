define (require) ->

  Backbone = require('backbone')

  Link = require('models/link')
  AddLinkModalView = require('views/threads/add-link-modal')
  AddUrlView = require('views/threads/add-url')
  SubmitCommentLinkView = require('views/threads/submit-comment-link')
  channel = require('modules/channel')

  describe "AddLinkModalView", ->
    beforeEach ->
      I18n.locale = 'en'
      @thread = sinon.stub()

    describe 'initialization', ->
      beforeEach -> @options = model: {}

      it 'throws no error if passed required options', ->
        expect(-> new AddLinkModalView(@options).not.toThrow())

      it 'throws error if not passed model (thread) in options', ->
        options = _.clone(@options)
        delete(options.model)
        expect(-> new AddLinkModalView(options)).toThrow('model required')

    describe 'rendering', ->
      beforeEach ->
        # create stub child modal view
        @modalView = new Backbone.View
        @modalView.render = () ->
          @el = document.createElement('div')
          @el.setAttribute('class', 'stub-modal')
          @
        @modalView.leave = ->
        sinon.spy(@modalView, 'render')

        @link = sinon.stub()
        @link.getUrl = -> 'http://www.example.com'

        @$sandbox = @createSandbox()
        @$modal = @createModal('add-link-modal')
        @$sandbox.append(@$modal)

      afterEach -> @destroySandbox()

      describe 'invalid step', ->
        it 'throws error', ->
          @view = new AddLinkModalView(model: @thread)
          @view.step = -1
          self = @
          expect(-> self.view.render()).toThrow('invalid step')

      #TODO: refactor this into shared examples
      describe 'add url (step 1)', ->
        beforeEach ->
          @AddUrlView = sinon.stub().returns(@modalView)
          @SubmitCommentLinkView = sinon.stub().returns(@modalView)
          @Link = sinon.stub().returns(@link)
          @view = new AddLinkModalView
            Link: @Link
            AddUrlView: @AddUrlView
            SubmitCommentLinkView: @SubmitCommentLinkView
            model: @thread

        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        describe 'cleaning up', ->
          it 'calls leave on any existing modal', ->
            modal = leave: ->
            sinon.spy(modal, 'leave')
            @view.modal = modal
            @view.render()
            expect(modal.leave).toHaveBeenCalledOnce()

          it 'creates a new link model', ->
            @view.render()
            expect(@Link.calledWithNew()).toBeTruthy()
            expect(@Link).toHaveBeenCalledWithExactly()

        describe 'element classes', ->

          it 'has default classes', ->
            @view.render()
            expect(@view.$el).toHaveClass('modal')
            expect(@view.$el).toHaveClass('hide')
            expect(@view.$el).toHaveClass('fade')

          it 'has add-url class', ->
            @view.render()
            expect(@view.$el).toHaveClass('add-url')

          it 'does not leave classes from other steps', ->
            originalClass = @view.render().$el.attr('class')
            @view.step = 2
            @view.render()
            @view.step = 1
            expect(@view.render().$el).toHaveAttr('class', originalClass)

        describe 'rendering the modal', ->

          it 'creates an AddUrlView', ->
            @view.render()
            expect(@AddUrlView).toHaveBeenCalledOnce()
            expect(@AddUrlView).toHaveBeenCalledWithExactly(
              model: @thread
              link: @link
            )

          it 'renders newly-created AddUrlView', ->
            $el = @view.render().$el
            expect(@modalView.render).toHaveBeenCalledOnce()

          it 'inserts form html into .modal-body element', ->
            $el = @view.render().$el
            expect($el).toContain('div.stub-modal')

      describe 'submit comment link (step 2)', ->
        beforeEach ->
          @SubmitCommentLinkView = sinon.stub().returns(@modalView)
          @Link = sinon.stub().returns(@link)
          @view = new AddLinkModalView
            SubmitCommentLinkView: @SubmitCommentLinkView
            Link: @Link
            model: @thread
            step: 2
          @view.link = @link

        it 'returns the view object', ->
          expect(@view.render()).toEqual(@view)

        describe 'cleaning up', ->
          it 'calls leave on any existing modal', ->
            modal = leave: ->
            sinon.spy(modal, 'leave')
            @view.modal = modal
            @view.render()
            expect(modal.leave).toHaveBeenCalledOnce()

        describe 'element classes', ->

          it 'has default classes', ->
            @view.render()
            expect(@view.$el).toHaveClass('modal')
            expect(@view.$el).toHaveClass('hide')
            expect(@view.$el).toHaveClass('fade')

          it 'has submit-comment-link class', ->
            @view.render()
            expect(@view.$el).toHaveClass('submit-comment-link')

          it 'does not leave classes from other steps', ->
            originalClass = @view.render().$el.attr('class')
            @view.step = 1
            @view.render()
            @view.step = 2
            expect(@view.render().$el).toHaveAttr('class', originalClass)

        describe 'rendering the modal', ->

          it 'does not create a new model', ->
            @view.render()
            expect(@Link.calledWithNew()).toBeFalsy()

          it 'creates a SubmitCommentLinkView', ->
            @view.render()
            expect(@SubmitCommentLinkView).toHaveBeenCalledOnce()
            expect(@SubmitCommentLinkView).toHaveBeenCalledWithExactly(model: @link, thread: @thread)

          it 'renders newly-created AddUrlView', ->
            $el = @view.render().$el
            expect(@modalView.render).toHaveBeenCalledOnce()

          it 'inserts form html into .modal-body element', ->
            $el = @view.render().$el
            expect($el).toContain('div.stub-modal')

        describe 'fetching link from store', ->

          it 'searches for link with same url in store, and replaces if found', ->
            linkInStore = new Link(id: 123, url: 'http://www.example.com')
            coll = Backbone.Relational.store.getCollection(Link)
            coll.add(linkInStore)
            @view.render()
            expect(@view.link).toBe(linkInStore)

    describe 'events', ->
      beforeEach ->
        @SubmitCommentLinkView = sinon.stub()
        @AddUrlView = sinon.stub()
        @Link = sinon.stub().returns(@link)
        @view = new AddLinkModalView
          SubmitCommentLinkView: @SubmitCommentLinkView
          AddUrlView: @AddUrlView
          Link: @Link
          model: @thread
        sinon.stub(@view, 'render')

      afterEach ->
        @view.render.restore()

      describe 'go to next step', ->
        it 'increments the step', ->
          channel.trigger('modal:next')
          expect(@view.step).toEqual(2)

        it 're-renders the view', ->
          channel.trigger('modal:next')
          expect(@view.render).toHaveBeenCalledOnce()
          expect(@view.render).toHaveBeenCalledWithExactly()

      describe 'go to previous step', ->
        it 'decrements the step if step > 1', ->
          @view.step = 2
          channel.trigger('modal:prev')
          expect(@view.step).toEqual(1)

        it 'does not change the step if step == 1', ->
          @view.step = 1
          channel.trigger('modal:prev')
          expect(@view.step).toEqual(1)

        it 're-renders the view', ->
          channel.trigger('modal:prev')
          expect(@view.render).toHaveBeenCalledOnce()
          expect(@view.render).toHaveBeenCalledWithExactly()

      describe 'unbinding channel events when leaving', ->
        it 'removes channel handlers when leaving', ->
          @view.leave()
          channel.trigger('modal:next')
          expect(@view.render).not.toHaveBeenCalled()
