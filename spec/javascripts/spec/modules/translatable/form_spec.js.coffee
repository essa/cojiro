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
        MyForm = _(Form).extend(options: template: "a template")
        @view = new Form(model: @model)

      it "creates a translatable form", ->
        $el = @view.$el
        expect($el).toBe('form')

      it "assigns a default template", ->
        expect(@view.options.template).toBeTruthy()

      it "throws error if model is not passed in", ->
        expect(-> new Form).toThrow("Translatable.Form needs a model to work with.")

      it "throws error if model is not a backbone model", ->
        expect(-> new Form(model: "foo")).toThrow("Translatable.Form's model must be a Backbone.Model.")
