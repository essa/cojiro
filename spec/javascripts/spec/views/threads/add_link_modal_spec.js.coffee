define (require) ->

  AddLinkModalView = require('views/threads/add_link_modal')

  describe "AddLinkModalView", ->
    beforeEach ->
      I18n.locale = 'en'

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
