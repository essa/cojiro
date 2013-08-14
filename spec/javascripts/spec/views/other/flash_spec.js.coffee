define (require) ->

  FlashView = require('views/other/flash')

  describe 'FlashView', ->

    describe 'rendering', ->

      it 'returns the view', ->
        view = new FlashView
        expect(view.render()).toEqual(view)

      it 'renders message', ->
        view = new FlashView(msg: 'a message')
        view.render()
        expect(view.$('.alert')).toContainText('a message')

      it 'renders alert classes', ->
        view = new FlashView(msg: 'a message', name: 'error')
        view.render()
        expect(view.$(':contains("a message")')).toHaveClass('alert alert-error error')

      it 'renders id', ->
        view = new FlashView(msg: 'a message', name: 'error')
        view.render()
        expect(view.$(':contains("a message")')).toHaveId('flash-error')
