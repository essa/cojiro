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
        schema: ->
          title:
            type: 'Text'
          summary:
            type: 'TextArea'
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
