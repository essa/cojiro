define (require) ->

  Backbone = require('backbone')
  Form = require('modules/translatable/form')
  Model = require('modules/translatable/model')
  MyModel = Model.extend(translatableAttributes: ["title", "summary"])

  describe "Translatable.Form", ->

    beforeEach ->
      I18n.locale = 'en'

    afterEach ->
      I18n.locale = I18n.defaultLocale

    beforeEach ->
      @model = new MyModel
      _(@model).extend
        id: "123"
        schema: -> {}
        @model.collection = new Backbone.Collection
        @model.collection.url = -> '/en/models'

    describe "instantiation", ->
      beforeEach ->
        @view = new Form(model: @model)

      it "creates a form", ->
        $el = @view.$el
        expect($el).toBe('form')

      it "assigns a default template", ->
        expect(@view.options.template).toBeTruthy()

      it "throws error if model is not passed in", ->
        expect(-> new Form).toThrow("Translatable.Form needs a model to work with.")

      it "throws error if model is not a backbone model", ->
        expect(-> new Form(model: "foo")).toThrow("Translatable.Form's model must be a Backbone.Model.")

      it "throws error if model has no schema", ->
        expect(-> new Form(model: new Backbone.Model)).toThrow("Translatable.Form's model must have a schema.")

      it "throws error if model has a schema that is not a function", ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: "foo"))).toThrow("Translatable.Form's model schema must be a function.")

      it "does not raise any error if passed a backbone model with a schema", ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: ->))).not.toThrow()

    describe "rendering", ->
      beforeEach ->
        @view = new Form(model: @model)

      it "renders form html", ->
        sinon.stub(@view, 'html').returns('some html')
        @view.render()
        expect(@view.$el).toHaveHtml('some html')

      it "returns view", ->
        expect(@view.render()).toBe(@view)

    describe "#html", ->
      beforeEach ->
        @view = new Form(model: @model)

      it "calls getItems with schema keys", ->
        sinon.stub(@view, 'getItems').returns(null)
        @view.html()
        expect(@view.getItems).toHaveBeenCalledOnce()

      it "inserts items into template", ->
        sinon.stub(@view, 'getItems').returns("items")
        template = sinon.stub()
        @view.options.template = template
        @view.html()
        expect(template).toHaveBeenCalledOnce()
        expect(template).toHaveBeenCalledWith(items: "items")

    describe "#getItems", ->
      it "maps elements to items", ->
        _(@model).extend(
          schema: -> attribute1: type: 'Text'
        )
        sinon.stub(@model, 'get').withArgs('attribute1').returns("a value")
        @view = new Form(model: @model)
        @view.cid = '123'
        sinon.stub(@view, 'getHtml').returns('html')
        expect(@view.getItems()).toEqual([
          { type: 'Text', html: 'html', label: 'attribute1', value: 'a value', cid: '123' }
        ])
