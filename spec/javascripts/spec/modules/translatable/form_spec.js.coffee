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

      it "assigns model schema to return value of schema function", ->
        schema = -> "foo"
        form = new Form(model: _(new Backbone.Model).extend(schema: schema))
        expect(form.schema()).toEqual("foo")

      it "assigns model schema to a function if it is a value", ->
        form = new Form(model: _(new Backbone.Model).extend(schema: "foo"))
        expect(form.schema()).toEqual("foo")

      it "does not throw any error if passed a backbone model with a schema", ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: ->))).not.toThrow()

      it "throws error if locales option is not an array", ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: ->), locales: "foo")).toThrow("Translatable.Form's locales must be an array of locale strings.")

      it "does not throw any error if locales option is an array", ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: ->), locales: ["foo"])).not.toThrow()

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
          @model.set('attribute1', 'value 1')
          @model.set('attribute2', 'value 2')
          @view = new Form(model: @model)
          @view.cid = '123'
          sinon.stub(@view, 'getHtml').returns('html')

        it "maps elements to items", ->
          _(@model).extend
            schema: ->
              attribute1: type: 'Text'
              attribute2: type: 'TextArea'
          expect(@view.getItems()).toEqual([
            { html: 'html', label: 'attribute1', key: 'attribute1', translated: false, cid: '123' }
            { html: 'html', label: 'attribute2', key: 'attribute2', translated: false, cid: '123' }
          ])

        it "assigns label if defined in schema", ->
          _(@model).extend
            schema: ->
              attribute1:
                label: 'Attribute 1'
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
          _(@model).extend
            schema: ->
              title:
                type: 'Text'
                label: 'Title'
          @model.set(
            title:
              en: "title in English"
              ja: "title in Japanese"
          )

        describe "with locales option unset, in Japanese locale", ->
          beforeEach ->
            @view = new Form(model: @model)
            @view.cid = '123'
            sinon.stub(@view, 'getHtml').returns('html')
            I18n.locale = "ja"

          it "sets translated to true", ->
            expect(@view.getItems()[0]['translated']).toBeTruthy()

          it "maps translated attributes to items with Japanese value only", ->
            expect(@view.getItems()).toEqual([
              html:
                ja: 'html'
              label: 'Title'
              key: 'title'
              translated: true
              cid: '123'
            ])

          it "calls getHtml on translation of schema item in Japanese only", ->
            @view.getItems()
            expect(@view.getHtml).toHaveBeenCalledOnce()
            expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in Japanese', 'Text', 'ja')

        describe "with locales option set", ->
          beforeEach ->
            @view = new Form(model: @model, locales: ["en", "ja"])
            @view.cid = '123'
            sinon.stub(@view, 'getHtml').returns('html')

          it "sets translated to true", ->
            expect(@view.getItems()[0]['translated']).toBeTruthy()

          it "maps translated attributes to items with values for selected locales", ->
            expect(@view.getItems()).toEqual([
              html:
                en: 'html'
                ja: 'html'
              label: 'Title'
              key: 'title'
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
            attribute:
              type: 'Text'
              label: 'My Attribute'
            title:
              type: 'Text'
              label: 'Title'
            summary:
              type: 'TextArea'
              label: (locale) -> 'Summary (' + locale + ')'
        )
        @model.set
          attribute: 'some attribute'
          title:
            en: 'Title in English'
            ja: 'Title in Japanese'
            fr: 'Title in French'
          summary:
            en: 'Summary in English'
            fr: 'Summary in French'
        @view = new Form(model: @model, locales: ["en", "ja"])
        @view.cid = '123'

      describe "untranslated attributes", ->

        it "renders fields", ->
          @view.render()
          expect(@view.$el).toContain('div.input input.xlarge#input-123-attribute[name="input-123-attribute"][type="text"][value="some attribute"]')

        it "renders labels", ->
          @view.render()
          expect(@view.$el).toContain('label[for="input-123-attribute"]:contains("My Attribute")')

      describe "translated attributes", ->

        it "renders fields for attribute translations specified in locales option", ->
          @view.render()
          # English
          expect(@view.$el).toContain('div.input input.xlarge#input-123-title-en[name="input-123-title-en"][type="text"][value="Title in English"]')
          expect(@view.$el).toContain('div.input textarea.xlarge#input-123-summary-en[name="input-123-summary-en"][type="text"][value="Summary in English"]')
          # Japanese
          expect(@view.$el).toContain('div.input input.xlarge#input-123-title-ja[name="input-123-title-ja"][type="text"][value="Title in Japanese"]')
          expect(@view.$el).toContain('div.input textarea.xlarge#input-123-summary-ja[name="input-123-summary-ja"][type="text"][value=""]')
          # French
          expect(@view.$el).not.toContain('div.input input.xlarge#input-123-title-fr[name="input-123-title-fr"][type="text"][value="Title in French"]')
          expect(@view.$el).not.toContain('div.input textarea.xlarge#input-123-summary-fr[name="input-123-summary-fr"][type="text"][value="Summary in French"]')

        it "renders label if label is a value", ->
          @view.render()
          expect(@view.$el).toContain('label[for="input-123-title-en"]:contains("Title")')

        it "calls function with locale as argument if label is a function", ->
          @view.render()
          expect(@view.$el).toContain('label[for="input-123-summary-en"]:contains("Summary (en)")')

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
          @view = new Form(model: @model, locales: ["en", "ja"])
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

        it "handles unset attributes", ->
          @model.set(
            title: new Attribute(en: 'a value in English')
          )
          @view.render()
          expect(@view.serialize()).toEqual({
            title:
              en: 'a value in English'
              ja: ''
            summary:
              en: ''
              ja: ''
          })
