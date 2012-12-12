define (require) ->

  Backbone = require('backbone')
  require('backbone-forms')
  Support = require('backbone-support')
  
  describe "Backbone.CompositeForm", ->
  beforeEach ->
    User = Backbone.Model.extend(schema: {})
    user = new User()
    @form = new Backbone.CompositeForm(model: user)
    @parentView = new Support.CompositeView()

  describe 'leave() called on parent CompositeView', ->
    beforeEach ->
      sinon.spy(@form, 'unbind')
      sinon.spy(@form, 'remove')
      sinon.spy(@parentView, '_removeChild')
      @parentView.renderChild(@form)
      @parentView.leave()

    it 'unbinds form', ->
      expect(@form.unbind).toHaveBeenCalledOnce()
      expect(@form.unbind).toHaveBeenCalledWithExactly()

    it 'removes form', ->
      expect(@form.remove).toHaveBeenCalledOnce()
      expect(@form.remove).toHaveBeenCalledWithExactly()

    it 'removes parent from form', ->
      expect(@parentView._removeChild).toHaveBeenCalledOnce()
      expect(@parentView._removeChild).toHaveBeenCalledWithExactly(@form)

