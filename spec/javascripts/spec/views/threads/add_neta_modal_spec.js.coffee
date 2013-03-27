define (require) ->

  AddNetaModalView = require('views/threads/add_neta_modal')

  describe "AddNetaModalView", ->
    beforeEach ->
      I18n.locale = 'en'

    describe "rendering", ->
      beforeEach ->
        @view = new AddNetaModalView

      afterEach ->
        I18n.locale = I18n.defaultLocale

      it "returns the view object", ->
        expect(@view.render()).toEqual(@view)

      it "renders URL input form", ->
        $el = @view.render().$el
        expect($el.find('.modal-header')).toHaveText(/Add a link/)
        expect($el.find('.modal-body')).toContain('form:contains("URL")')
