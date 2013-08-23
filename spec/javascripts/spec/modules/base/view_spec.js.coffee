define (require) ->

  _ = require 'underscore'
  Backbone = require 'backbone'
  Support = require 'backbone-support'
  BaseView = require 'modules/base/view'

  describe "BaseView", ->
    beforeEach ->
      @baseView = new BaseView

    it 'extends Support.CompositeView', ->
      expect(@baseView instanceof Support.CompositeView).toBeTruthy()

    describe "#buildEvents", ->

      it 'returns an empty object', ->
        expect(@baseView.buildEvents()).toEqual({})

    describe 'rendering', ->
      it 'renders template with empty params', ->
        @baseView.template = _.template '<div class="myDiv"></div>'
        @baseView.render()
        expect(@baseView.$el).toContain('div.myDiv')

    describe 'template', ->
      it 'returns a blank template', -> expect(@baseView.template()).toEqual('')

    describe "initialize", ->

      it "delegates events", ->
        spy = sinon.stub(@baseView, 'delegateEvents')
        @baseView.buildEvents = () ->
          "click button": "eventHandler"
        @baseView.initialize()
        expect(spy).toHaveBeenCalledOnce()
        expect(spy).toHaveBeenCalledWith({ "click button": "eventHandler" })
