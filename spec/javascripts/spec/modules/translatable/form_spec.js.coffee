define (require) ->

  Backbone = require('backbone')
  I18n = require('i18n')
  Form = require('modules/translatable/form')
  Model = require('modules/translatable/model')
  Attribute = require('modules/translatable/attribute')
  MyModel = Model.extend(translatableAttributes: ['title', 'summary'])

  describe 'Translatable.Form', ->

    beforeEach ->
      I18n.locale = 'en'

    afterEach ->
      I18n.locale = I18n.defaultLocale

    beforeEach ->
      @model = new MyModel
      _(@model).extend
        id: '123'
        schema: -> {}

    describe 'instantiation', ->
      beforeEach ->
        @view = new Form(model: @model)

      it 'creates a form', ->
        $el = @view.$el
        expect($el).toBe('form')

      it 'assigns a default template', ->
        expect(@view.options.template).toBeTruthy()

      it 'throws error if model is not passed in', ->
        expect(-> new Form).toThrow('Translatable.Form needs a model to work with.')

      it 'throws error if model is not a backbone model', ->
        expect(-> new Form(model: 'foo')).toThrow('Translatable.Form\'s model must be a Backbone.Model.')

      it 'throws error if model has no schema', ->
        expect(-> new Form(model: new Backbone.Model)).toThrow('Translatable.Form\'s model must have a schema.')

      it 'assigns model schema to return value of schema function', ->
        schema = -> 'foo'
        form = new Form(model: _(new Backbone.Model).extend(schema: schema))
        expect(form.schema()).toEqual('foo')

      it 'assigns model schema to a function if it is a value', ->
        form = new Form(model: _(new Backbone.Model).extend(schema: 'foo'))
        expect(form.schema()).toEqual('foo')

      it 'does not throw any error if passed a backbone model with a schema', ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: ->))).not.toThrow()

      it 'throws error if locales option is not an array', ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: ->), locales: 'foo')).toThrow('Translatable.Form\'s locales must be an array of locale strings.')

      it 'does not throw any error if locales option is an array', ->
        expect(-> new Form(model: _(new Backbone.Model).extend(schema: ->), locales: ['foo'])).not.toThrow()

    describe 'rendering', ->
      beforeEach ->
        @view = new Form(model: @model)

      it 'renders form html', ->
        sinon.stub(@view, 'html').returns('some html')
        @view.render()
        expect(@view.$el).toHaveHtml('some html')

      it 'returns view', ->
        expect(@view.render()).toBe(@view)

    describe '#html', ->
      beforeEach ->
        @view = new Form(model: @model)

      it 'calls getItems', ->
        sinon.stub(@view, 'getItems')
        @view.html()
        expect(@view.getItems).toHaveBeenCalledOnce()
        expect(@view.getItems).toHaveBeenCalledWithExactly()

      it 'inserts items into template', ->
        sinon.stub(@view, 'getItems').returns('items')
        template = sinon.stub()
        @view.options.template = template
        @view.html()
        expect(template).toHaveBeenCalledOnce()
        expect(template).toHaveBeenCalledWithExactly(items: 'items')

    describe '#getItems', ->

      describe 'untranslated attributes', ->
        beforeEach ->
          @model.set('attribute1', 'value 1')
          @model.set('attribute2', 'value 2')
          @model.set('attribute3', 'value 3')
          @view = new Form(model: @model)
          @view.cid = '123'
          sinon.stub(@view, 'getHtml').returns('html')

        it 'maps elements to items', ->
          _(@model).extend
            schema: ->
              attribute1: type: 'Text'
              attribute2: type: 'TextArea'
              attribute3: type: 'Select'
          expect(@view.getItems()).toEqual([
            { html: 'html', label: 'attribute1', key: 'attribute1', translated: false, cid: '123' }
            { html: 'html', label: 'attribute2', key: 'attribute2', translated: false, cid: '123' }
            { html: 'html', label: 'attribute3', key: 'attribute3', translated: false, cid: '123' }
          ])

        it 'assigns label if defined in schema', ->
          _(@model).extend
            schema: ->
              attribute1:
                label: 'Attribute 1'
                type: 'Text'
              attribute2: type: 'TextArea'
          items = @view.getItems()
          expect(items[0]['label']).toEqual('Attribute 1')
          expect(items[1]['label']).toEqual('attribute2')

        it 'calls getHtml on each schema item', ->
          _(@model).extend
            schema: ->
              attribute1: type: 'Text'
              attribute2: type: 'TextArea'
              attribute3:
                type: 'Select'
                values: 'values'
          @view.getItems()
          expect(@view.getHtml).toHaveBeenCalledThrice()
          expect(@view.getHtml).toHaveBeenCalledWith('attribute1', 'value 1', 'Text')
          expect(@view.getHtml).toHaveBeenCalledWith('attribute2', 'value 2', 'TextArea')
          expect(@view.getHtml).toHaveBeenCalledWith('attribute3', 'value 3', 'Select', values: 'values')

      describe 'translated attributes', ->
        beforeEach ->
          _(@model).extend
            schema: ->
              title:
                type: 'Text'
                label: 'Title'
          @model.set(
            title:
              en: 'title in English'
              ja: 'title in Japanese'
          )

        describe 'with locales option unset', ->
          beforeEach ->
            @view = new Form(model: @model, wildcard: 'xyz')
            @view.cid = '123'
            sinon.stub(@view, 'getHtml').returns('html')
            I18n.locale = 'ja'

          it 'sets translated to true', ->
            expect(@view.getItems()[0]['translated']).toBeTruthy()

          it 'maps translated attributes to items with wildcard locale', ->
            expect(@view.getItems()).toEqual([
              html:
                xyz: 'html'
              label: 'Title'
              key: 'title'
              translated: true
              cid: '123'
            ])

          it 'calls getHtml with attribute and value in current locale', ->
            @view.getItems()
            expect(@view.getHtml).toHaveBeenCalledOnce()
            expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in Japanese', 'Text', locale: 'xyz')

        describe 'with locales option set', ->
          beforeEach ->
            @view = new Form(model: @model, locales: ['en', 'ja'])
            @view.cid = '123'
            sinon.stub(@view, 'getHtml').returns('html')

          it 'sets translated to true', ->
            expect(@view.getItems()[0]['translated']).toBeTruthy()

          it 'maps translated attributes to items with values for selected locales', ->
            expect(@view.getItems()).toEqual([
              html:
                en: 'html'
                ja: 'html'
              label: 'Title'
              key: 'title'
              translated: true
              cid: '123'
            ])

          it 'calls getHtml on each translation of schema items', ->
            @view.getItems()
            expect(@view.getHtml).toHaveBeenCalledTwice()
            expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in English', 'Text', locale: 'en')
            expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in Japanese', 'Text', locale: 'ja')

    describe '#getHtml', ->
      beforeEach ->
        @view = new Form(model: @model)
        @view.cid = '123'

      describe 'untranslated attributes', ->

        describe 'Text', ->
          it 'creates correct html for Text type', ->
            expect(@view.getHtml('attribute', 'value', 'Text')).toContain('<input id="123-attribute" name="attribute" type="text" value="value"/>')

        describe 'TextArea', ->
          it 'creates correct html for TextArea type', ->
            expect(@view.getHtml('attribute', 'value', 'TextArea')).toContain('<textarea id="123-attribute" name="attribute" type="text" rows="3">value</textarea>')

        describe 'Select', ->

          it 'creates correct select tag', ->
            options = values: { en: 'English', ja: 'Japanese', fr: 'French' }
            expect(@view.getHtml('attribute', 'fr', 'Select', options)).toContain([
              '<select id="123-attribute" name="attribute">'
              '<option value="en">English</option>'
              '<option value="ja">Japanese</option>'
              '<option value="fr" selected="selected">French</option>'
              '</select>'].join(''))

        describe 'other values', ->
          it 'creates correct html for attributes with undefined value', ->
            expect(@view.getHtml('attribute', undefined, 'TextArea')).toContain('<textarea id="123-attribute" name="attribute" type="text" rows="3"></textarea>')

          it 'creates correct html for attributes with null value', ->
            expect(@view.getHtml('attribute', null, 'TextArea')).toContain('<textarea id="123-attribute" name="attribute" type="text" rows="3"></textarea>')

      describe 'translated attributes', ->
        it 'adds lang tag and appends lang to attribute name', ->
          expect(@view.getHtml('attribute', 'value', 'Text', locale: 'en')).toContain('<input id="123-attribute-en" name="attribute-en" type="text" value="value" lang="en"/>')

    describe 'default template (output)', ->
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
        @view = new Form(model: @model, locales: ['en', 'ja'])
        @view.cid = '123'

      describe 'untranslated attributes', ->

        it 'renders fields', ->
          @view.render()
          expect(@view.$el).toContain('.control-group.attribute input#123-attribute[name="attribute"][type="text"][value="some attribute"]')

        it 'renders labels', ->
          @view.render()
          expect(@view.$el).toContain('.control-group.attribute label[for="123-attribute"]:contains("My Attribute")')

      describe 'translated attributes', ->

        it 'renders fields for attribute translations specified in locales option', ->
          @view.render()
          # English
          expect(@view.$el).toContain('.control-group.title.title-en input#123-title-en[name="title-en"][type="text"][value="Title in English"]')
          expect(@view.$el).toContain('.control-group.summary.summary-en textarea#123-summary-en[name="summary-en"][type="text"]:contains("Summary in English")')
          # Japanese
          expect(@view.$el).toContain('.control-group.title.title-ja input#123-title-ja[name="title-ja"][type="text"][value="Title in Japanese"]')
          expect(@view.$el).toContain('.control-group.summary.summary-ja textarea#123-summary-ja[name="summary-ja"][type="text"]:contains("")')
          # French
          expect(@view.$el).not.toContain('.control-group.title.title-fr input#123-title-fr[name="title-fr"][type="text"][value="Title in French"]')
          expect(@view.$el).not.toContain('.control-group.summary.summary-fr textarea#123-summary-fr[name="summary-fr"][type="text"]:contains("Summary in French")')

        it 'renders label if label is a value', ->
          @view.render()
          expect(@view.$el).toContain('label[for="123-title-en"]:contains("Title")')

        it 'calls function with locale as argument if label is a function', ->
          @view.render()
          expect(@view.$el).toContain('label[for="123-summary-en"]:contains("Summary (en)")')

    describe '#serialize', ->
      it 'throws error if no form tag is found', ->
        @view = new Form(tagName: 'div', model: @model)
        @view.tagName = 'div'
        expect(@view.serialize).toThrow('Serialize must operate on a form element.')

      describe 'untranslated data', ->
        beforeEach ->
          _(@model).extend(
            schema: ->
              attribute1: type: 'Text'
              attribute2: type: 'TextArea'
          )
          @view = new Form(model: @model)
          @view.cid = '123'
          @view.render()

        it 'serializes form data', ->
          @view.$el.find('input#123-attribute1').val('a new value')
          @view.$el.find('textarea#123-attribute2').val('another new value')
          expect(@view.serialize()).toEqual(
            attribute1: 'a new value'
            attribute2: 'another new value'
          )

        it 'handles empty fields', ->
          expect(@view.serialize()).toEqual(
            attribute1: ''
            attribute2: ''
          )

      describe 'translated data', ->
        beforeEach ->
          _(@model).extend(
            schema: ->
              title: type: 'Text'
              summary: type: 'TextArea'
          )
          @view = new Form(model: @model, locales: ['en', 'ja'])
          @view.cid = '123'

        it 'serializes translated form data', ->
          @model.set(
            title: new Attribute(en: '', ja: '')
            summary: new Attribute(en: '', ja: '')
          )
          @view.render()
          @view.$el.find('input#123-title-en').val('a value in English')
          @view.$el.find('input#123-title-ja').val('a value in Japanese')
          expect(@view.serialize()).toEqual(
            title:
              en: 'a value in English'
              ja: 'a value in Japanese'
            summary:
              en: ''
              ja: ''
          )

        it 'handles unset attributes', ->
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

    describe '#renderErrors', ->

      describe 'with locales passed in', ->
        beforeEach ->
          @view = new Form(model: @model, locales: ['en'])
          @view.cid = '123'

        describe 'untranslated attributes', ->
          beforeEach ->
            _(@model).extend
              schema: ->
                attribute: type: 'Text'
            @view.render()

          it 'appends error class to control-group for each attribute in errors object', ->
            @view.renderErrors(attribute: 'required')
            $field = @view.$el.find('input#123-attribute')
            expect($field.closest('.control-group')).toHaveClass('error')

          it 'inserts error msg into help block', ->
            @view.renderErrors(attribute: 'required')
            $field = @view.$el.find('input#123-attribute')
            expect($field.closest('.controls').find('.help-block')).toHaveText('required')

        describe 'translated (nested) attributes', ->
          beforeEach ->
            _(@model).extend
              schema: ->
                title: type: 'Text'
            @view.render()

          it 'appends error class to control-group for each attribute in errors object', ->
            @view.renderErrors(title: en: 'required')
            $field = @view.$el.find('input#123-title-en')
            expect($field.closest('.control-group')).toHaveClass('error')

          it 'inserts error msg into help block', ->
            @view.renderErrors(title: en: 'required')
            $field = @view.$el.find('input#123-title-en')
            expect($field.closest('.controls').find('.help-block')).toHaveText('required')

      describe 'with locales dynamically assigned', ->

        describe 'default sourceLocale function', ->
          beforeEach ->
            @view = new Form(model: @model, wildcard: 'xyz')
            @view.cid = '123'
            _(@model).extend schema: -> title: type: 'Text'
            @view.render()

          it 'maps errors on current locale to wildcard', ->
            I18n.locale = 'fr'
            @view.renderErrors(title: fr: 'required')
            $field = @view.$el.find('input#123-title-xyz')
            expect($field.closest('.control-group')).toHaveClass('error')
            expect($field.closest('.controls').find('.help-block')).toHaveText('required')

          it 'does not map errors on other locales to wildcard', ->
            I18n.locale = 'fr'
            @view.renderErrors(title: ja: 'required')
            $field = @view.$el.find('input#123-title-xyz')
            expect($field.closest('.control-group')).not.toHaveClass('error')
            expect($field.closest('.controls').find('.help-block')).not.toHaveText('required')

          # This is a somewhat contrived example, but suppose we have a custom
          # template which shows fields for locales other than the source locale,
          # and we want to render those errors on those locales.
          # Then renderError should correctly render those locale-specific errors
          # *in addition* to the errors it renders on the source locale.
          it 'maps errors on other locales to attributes in that locale', ->
            @view.$('fieldset').append '
              <div class="control-group">
                <div class="controls">
                  <input id="123-title-ja" name="title-ja" type="text" value="" />
                  <div class="help-block"></div>
                </div>
              </div>'
            @view.renderErrors(title: ja: 'required')
            $field = @view.$el.find('input#123-title-ja')
            expect($field.closest('.control-group')).toHaveClass('error')
            expect($field.closest('.controls').find('.help-block')).toHaveText('required')

        describe 'custom sourceLocale function', ->
          beforeEach ->
            @view = new Form
              model: @model
              wildcard: 'xyz'
              sourceLocale: -> 'de'
            @view.cid = '123'
            _(@model).extend schema: -> title: type: 'Text'
            @view.render()

          it 'maps errors on source locale to wildcard', ->
            @view.renderErrors(title: de: 'required')
            $field = @view.$el.find('input#123-title-xyz')
            expect($field.closest('.control-group')).toHaveClass('error')
            expect($field.closest('.controls').find('.help-block')).toHaveText('required')

          it 'does not map errors on other locales to wildcard', ->
            @view.renderErrors(title: ja: 'required')
            $field = @view.$el.find('input#123-title-xyz')
            expect($field.closest('.control-group')).not.toHaveClass('error')
            expect($field.closest('.controls').find('.help-block')).not.toHaveText('required')
