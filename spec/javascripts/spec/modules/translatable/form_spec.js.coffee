define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')
  Form = require('modules/translatable/form')
  Model = require('modules/translatable/model')
  Attribute = require('modules/translatable/attribute')
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

      it "calls getItems", ->
        sinon.stub(@view, 'getItems')
        @view.html()
        expect(@view.getItems).toHaveBeenCalledOnce()
        expect(@view.getItems).toHaveBeenCalledWithExactly()

      it "inserts items into template", ->
        sinon.stub(@view, 'getItems').returns("items")
        template = sinon.stub()
        @view.options.template = template
        @view.html()
        expect(template).toHaveBeenCalledOnce()
        expect(template).toHaveBeenCalledWithExactly(items: "items")

    describe "#getItems", ->

      describe "untranslated attributes", ->
        beforeEach ->
          sinon.stub(@model, 'get', (arg) ->
            switch arg
              when 'attribute1' then 'value 1'
              when 'attribute2' then 'value 2'
          )
          @view = new Form(model: @model)
          @view.cid = '123'
          sinon.stub(@view, 'getHtml').returns('html')

        it "maps elements to items", ->
          _(@model).extend
            schema: ->
              attribute1: type: 'Text'
              attribute2: type: 'TextArea'
          expect(@view.getItems()).toEqual([
            { html: 'html', label: 'attribute1', translated: false, cid: '123' }
            { html: 'html', label: 'attribute2', translated: false, cid: '123' }
          ])

        it "assigns label if title is defined in schema", ->
          _(@model).extend
            schema: ->
              attribute1:
                title: 'Attribute 1'
                type: 'Text'
              attribute2: type: 'TextArea'
          items = @view.getItems()
          expect(items[0]['label']).toEqual('Attribute 1')
          expect(items[1]['label']).toEqual('attribute2')

        it "calls getHtml on each schema item", ->
          _(@model).extend
            schema: ->
              attribute1: type: 'Text'
              attribute2: type: 'TextArea'
          @view.getItems()
          expect(@view.getHtml).toHaveBeenCalledTwice()
          expect(@view.getHtml).toHaveBeenCalledWith('attribute1', 'value 1', 'Text')
          expect(@view.getHtml).toHaveBeenCalledWith('attribute2', 'value 2', 'TextArea')

      describe "translated attributes", ->
        beforeEach ->
          @view = new Form(model: @model)
          @view.cid = '123'
          _(@model).extend
            schema: ->
              title:
                type: 'Text'
                title: 'Title'
          sinon.stub(@view, 'getHtml').returns('html')
          sinon.stub(@model, 'get', (arg) -> new Attribute(en: "title in English", ja: "title in Japanese"))

        it "sets translated to true", ->
          expect(@view.getItems()[0]['translated']).toBeTruthy()

        it "maps translated attributes to items", ->
          expect(@view.getItems()).toEqual([
            html:
              en: 'html'
              ja: 'html'
            label: 'Title'
            translated: true
            cid: '123'
          ])

        it "calls getHtml on each translation of schema items", ->
          @view.getItems()
          expect(@view.getHtml).toHaveBeenCalledTwice()
          expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in English', 'Text', 'en')
          expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in Japanese', 'Text', 'ja')

    describe "#getHtml", ->
      beforeEach ->
        @view = new Form(model: @model)
        @view.cid = '123'

      describe "untranslated attributes", ->
        it "creates correct html for Text type", ->
          expect(@view.getHtml("attribute", "value", "Text")).toEqual('<input class="xlarge" id="input-123-attribute" name="input-123-attribute" size="30" type="text" value="value" />')

        it "creates correct html for TextArea type", ->
          expect(@view.getHtml("attribute", "value", "TextArea")).toEqual('<textarea class="xlarge" id="input-123-attribute" name="input-123-attribute" size="30" type="text" value="value" />')

        it "creates correct html for attributes with undefined value", ->
          expect(@view.getHtml("attribute", undefined, "TextArea")).toEqual('<textarea class="xlarge" id="input-123-attribute" name="input-123-attribute" size="30" type="text" value="" />')

        it "creates correct html for attributes with null value", ->
          expect(@view.getHtml("attribute", null, "TextArea")).toEqual('<textarea class="xlarge" id="input-123-attribute" name="input-123-attribute" size="30" type="text" value="" />')

      describe "translated attributes", ->
        it "adds lang tag and appends lang to attribute name", ->
          expect(@view.getHtml("attribute", "value", "Text", "en")).toEqual('<input class="xlarge" id="input-123-attribute-en" name="input-123-attribute-en" size="30" type="text" value="value" lang="en"/>')

    describe "default template (output)", ->
      beforeEach ->
        _(@model).extend(
          schema: ->
            attribute: type: 'Text'
            title: type: 'Text'
            summary: type: 'TextArea'
        )
        @model.set
          attribute: 'some attribute'
          title:
            en: 'Title in English'
            ja: 'Title in Japanese'
          summary:
            en: 'Summary in English'
            fr: 'Summary in French'
        @view = new Form(model: @model)
        @view.cid = '123'

      describe "untranslated attributes", ->

        it "renders fields", ->
          @view.render()
          expect(@view.$el).toContain('div.input input.xlarge#input-123-attribute[name="input-123-attribute"][type="text"][value="some attribute"]')

        it "renders labels", ->
          @view.render()
          expect(@view.$el).toContain('label[for="input-123-attribute"]:contains("attribute")')

      describe "translated attributes", ->

        it "renders fields for attribute translations", ->
          @view.render()
          # English
          expect(@view.$el).toContain('div.input input.xlarge#input-123-title-en[name="input-123-title-en"][type="text"][value="Title in English"]')
          expect(@view.$el).toContain('div.input textarea.xlarge#input-123-summary-en[name="input-123-summary-en"][type="text"][value="Summary in English"]')
          # Japanese
          expect(@view.$el).toContain('div.input input.xlarge#input-123-title-ja[name="input-123-title-ja"][type="text"][value="Title in Japanese"]')
          # French
          expect(@view.$el).toContain('div.input textarea.xlarge#input-123-summary-fr[name="input-123-summary-fr"][type="text"][value="Summary in French"]')

    describe "#serialize", ->
      it "throws error if no form tag is found", ->
        @view = new Form(tagName: 'div', model: @model)
        @view.tagName = 'div'
        expect(@view.serialize).toThrow("Serialize must operate on a form element.")

      describe "untranslated data", ->
        beforeEach ->
          _(@model).extend(
            schema: ->
              attribute1: type: 'Text'
              attribute2: type: 'TextArea'
          )
          @view = new Form(model: @model)
          @view.cid = '123'
          @view.render()

        it "serializes form data", ->
          @view.$el.find('input#input-123-attribute1').val('a new value')
          @view.$el.find('textarea#input-123-attribute2').val('another new value')
          expect(@view.serialize()).toEqual(
            attribute1: 'a new value'
            attribute2: 'another new value'
          )

        it "handles empty fields", ->
          expect(@view.serialize()).toEqual(
            attribute1: ''
            attribute2: ''
          )

      describe "translated data", ->
        beforeEach ->
          _(@model).extend(
            schema: ->
              title: type: 'Text'
              summary: type: 'TextArea'
          )
          @view = new Form(model: @model)
          @view.cid = '123'

        it "serializes translated form data", ->
          @model.set(
            title: new Attribute(en: "", ja: "")
            summary: new Attribute(en: "", ja: "")
          )
          @view.render()
          @view.$el.find('input#input-123-title-en').val('a value in English')
          @view.$el.find('input#input-123-title-ja').val('a value in Japanese')
          expect(@view.serialize()).toEqual(
            title:
              en: 'a value in English'
              ja: 'a value in Japanese'
            summary:
              en: ''
              ja: ''
          )

        it "handles empty fields", ->
          @model.set(
            title: new Attribute(en: 'a value in English')
          )
          @view.render()
          expect(@view.serialize()).toEqual({
            title:
              en: 'a value in English'
          })
