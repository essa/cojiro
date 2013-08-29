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

    describe 'initialization', ->
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

    describe 'events', ->

      describe 'error on model', ->
        beforeEach ->
          _(@model).extend
            schema: ->
              attribute:
                label: 'Attribute'
                type: 'Text'
          @view = new Form(model: @model)
          @view.cid = '123'
          @view.render()

        it 'renders errors', ->
          error = attribute: 'required'
          @model.trigger('invalid', @, error)
          $field = @view.$el.findField('Attribute')
          expect($field.closest('.control-group')).toHaveClass('error')

      describe 'changeLocale', ->
        beforeEach ->
          _(@model).extend
            schema: ->
              title:
                label: 'Title'
                type: 'Text'
              summary:
                label: (locale) -> if locale then ('Summary (' + locale + ')') else 'Summary'
                type: 'TextArea'
          @view = new Form(model: @model)
          @view.cid = '123'
          @view.render()

        it 'changes locale-related tags of form input fields', ->
          @view.trigger('changeLocale', 'ja')
          expect(@view.$el).toContain('.control-group.title input#123-title-ja[name="title-ja"][type="text"][lang="ja"]')
          expect(@view.$el).toContain('.control-group.title input#123-title-ja[name="title-ja"][type="text"][lang="ja"]')
          expect(@view.$el).not.toContain('#123-title-en')
          expect(@view.$el).not.toContain('#123-summary-en')

        it 'changes labels', ->
          @view.trigger('changeLocale', 'ja')
          expect(@view.$el.find('label[for="123-summary-ja"]')).toHaveText('Summary (ja)')

        it 'retains original input field values', ->
          @$el = @view.$el
          @$el.findField('Title').val('a title')
          @$el.findField('Summary').val('a summary')
          @view.trigger('changeLocale', 'ja')
          expect(@$el.findField('Title')).toHaveValue('a title')
          expect(@$el.findField('Summary')).toHaveValue('a summary')

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
                label: (locale) -> if locale then ('Title (' + locale + ')') else 'Title'
          @model.set(
            title:
              en: 'title in English'
              ja: 'title in Japanese'
              fr: 'title in French'
          )
          @model.setSourceLocale('fr')

        describe 'with locales option unset', ->
          beforeEach ->
            @view = new Form(model: @model)
            @view.cid = '123'
            sinon.stub(@view, 'getHtml').returns('html')
            I18n.locale = 'ja'
            @item = @view.getItems()[0]

          it 'sets translated to true', ->
            expect(@item['translated']).toBeTruthy()

          it 'sets sourceLocale and sourceValue', ->
            expect(@item.sourceLocale).toEqual('fr')
            expect(@item.sourceValue).toEqual('title in French')

          it 'maps translated attributes to items with current locale', ->
            expect(@item.html).toEqual(ja: 'html')
            expect(@item.key).toEqual('title')
            expect(@item.cid).toEqual('123')

          it 'sets label function to result of schema label function for attribute called with no argument', ->
            expect(@item.label).toEqual('Title')

          it 'calls getHtml with attribute and value in current locale', ->
            expect(@view.getHtml).toHaveBeenCalledOnce()
            expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in Japanese', 'Text', locale: 'ja', sourceLocale: 'fr')

        describe 'with locales option set', ->
          beforeEach ->
            @view = new Form(model: @model, locales: ['en', 'ja'])
            @view.cid = '123'
            sinon.stub(@view, 'getHtml').returns('html')
            @item = @view.getItems()[0]

          it 'sets translated to true', ->
            expect(@item['translated']).toBeTruthy()

          it 'sets sourceLocale and sourceValue', ->
            expect(@item.sourceLocale).toEqual('fr')
            expect(@item.sourceValue).toEqual('title in French')

          it 'maps translated attributes to items with values for selected locales', ->
            expect(@item.html).toEqual(en: 'html', ja: 'html')
            expect(@item.key).toEqual('title')
            expect(@item.cid).toEqual('123')

          it 'sets label function to schema label function for attribute', ->
            expect(@item.label('en')).toEqual(@model.schema().title.label('en'))
            expect(@item.label('ja')).toEqual(@model.schema().title.label('ja'))

          it 'calls getHtml on each translation of schema items', ->
            expect(@view.getHtml).toHaveBeenCalledTwice()
            expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in English', 'Text', locale: 'en', sourceLocale: 'fr')
            expect(@view.getHtml).toHaveBeenCalledWith('title', 'title in Japanese', 'Text', locale: 'ja', sourceLocale: 'fr')

    describe '#getHtml', ->
      beforeEach ->
        @view = new Form(model: @model)
        @view.cid = '123'

      describe 'untranslated attributes', ->

        describe 'Text', ->
          it 'creates correct html for Text type', ->
            $el = $(@view.getHtml('attribute', 'value', 'Text'))
            expect($el).toBe('input')
            expect($el).toHaveId('123-attribute')
            expect($el).toHaveAttr('name', 'attribute')
            expect($el).toHaveAttr('type', 'text')
            expect($el).toHaveValue('value')
            expect($el).not.toHaveAttr('lang')

        describe 'TextArea', ->
          it 'creates correct html for TextArea type', ->
            $el = $(@view.getHtml('attribute', 'value', 'TextArea'))
            expect($el).toBe('textarea')
            expect($el).toHaveId('123-attribute')
            expect($el).toHaveAttr('name', 'attribute')
            expect($el).toHaveAttr('type', 'text')
            expect($el).toHaveAttr('rows', '3')
            expect($el).toHaveValue('value')
            expect($el).not.toHaveAttr('lang')

        describe 'Select', ->
          beforeEach -> @options = values: { en: 'English', ja: 'Japanese', fr: 'French' }

          it 'creates correct select tag', ->
            $el = $(@view.getHtml('attribute', 'fr', 'Select', @options))
            expect($el).toBe('select')
            expect($el).toHaveId('123-attribute')
            expect($el).toHaveAttr('name', 'attribute')

          it 'creates correct options', ->
            $els = $(@view.getHtml('attribute', 'fr', 'Select', @options)).find('option')
            expect($els[0]).toHaveValue('en')
            expect($els[0]).toHaveText('English')
            expect($els[0]).not.toHaveAttr('selected')
            expect($els[1]).toHaveValue('ja')
            expect($els[1]).toHaveText('Japanese')
            expect($els[1]).not.toHaveAttr('selected')
            expect($els[2]).toHaveValue('fr')
            expect($els[2]).toHaveText('French')
            expect($els[2]).toHaveAttr('selected')

        describe 'other values', ->
          it 'creates correct html for attributes with undefined value', ->
            $el = $(@view.getHtml('attribute', undefined, 'TextArea'))
            expect($el).toBe('textarea')
            expect($el).toHaveId('123-attribute')
            expect($el).toHaveAttr('name', 'attribute')
            expect($el).toHaveAttr('type', 'text')
            expect($el).not.toHaveAttr('value')

          it 'creates correct html for attributes with null value', ->
            $el = $(@view.getHtml('attribute', null, 'TextArea'))
            expect($el).toBe('textarea')
            expect($el).toHaveId('123-attribute')
            expect($el).toHaveAttr('name', 'attribute')
            expect($el).toHaveAttr('type', 'text')
            expect($el).not.toHaveAttr('value')

      describe 'translated attributes', ->
        describe 'Text', ->

          it 'adds lang tag and appends lang to attribute name', ->
            $el = $(@view.getHtml('attribute', 'value', 'Text', locale: 'en'))
            expect($el).toBe('input')
            expect($el).toHaveId('123-attribute-en')
            expect($el).toHaveAttr('name', 'attribute-en')
            expect($el).toHaveAttr('type', 'text')
            expect($el).toHaveAttr('lang', 'en')
            expect($el).toHaveValue('value')

          describe 'when locale is the source locale', ->

            it 'does not add placeholder text', ->
              $el = $(@view.getHtml('attribute', 'value', 'Text', locale: 'fr', sourceLocale: 'fr'))
              expect($el).not.toHaveAttr('placeholder')

          describe 'when locale is different from the source locale', ->

            it 'adds placeholder text', ->
              $el = $(@view.getHtml('attribute', 'value', 'Text', locale: 'fr', sourceLocale: 'ja'))
              expect($el).toHaveAttr('placeholder', 'Translate to French')

          describe 'when source locale is not set', ->

            it 'does not add placeholder text', ->
              $el = $(@view.getHtml('attribute', 'value', 'Text', locale: 'fr', sourceLocale: undefined))
              expect($el).not.toHaveAttr('placeholder')

        describe 'TextArea', ->
          it 'adds lang tag and appends lang to attribute name', ->
            $el = $(@view.getHtml('attribute', 'value', 'TextArea', locale: 'en'))
            expect($el).toBe('textarea')
            expect($el).toHaveId('123-attribute-en')
            expect($el).toHaveAttr('name', 'attribute-en')
            expect($el).toHaveAttr('type', 'text')
            expect($el).toHaveAttr('lang', 'en')
            expect($el).toHaveValue('value')

          describe 'when locale is the source locale', ->

            it 'does not add placeholder text', ->
              $el = $(@view.getHtml('attribute', 'value', 'TextArea', locale: 'fr', sourceLocale: 'fr'))
              expect($el).not.toHaveAttr('placeholder')

          describe 'when locale is different from the source locale', ->

            it 'adds placeholder text', ->
              $el = $(@view.getHtml('attribute', 'value', 'TextArea', locale: 'fr', sourceLocale: 'ja'))
              expect($el).toHaveAttr('placeholder', 'Translate to French')

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
          source_locale: 'ja'
          title:
            en: 'Title in English'
            ja: 'Title in Japanese'
            fr: 'Title in French'
          summary:
            en: 'Summary in English'
            ja: 'Summary in Japanese'
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
          expect(@view.$el).toContain('.control-group.title input#123-title-en[name="title-en"][type="text"][value="Title in English"]')
          expect(@view.$el).toContain('.control-group.summary textarea#123-summary-en[name="summary-en"][type="text"]:contains("Summary in English")')
          # Japanese
          expect(@view.$el).toContain('.control-group.title input#123-title-ja[name="title-ja"][type="text"][value="Title in Japanese"]')
          expect(@view.$el).toContain('.control-group.summary textarea#123-summary-ja[name="summary-ja"][type="text"]:contains("")')
          # French
          expect(@view.$el).not.toContain('.control-group.title input#123-title-fr[name="title-fr"][type="text"][value="Title in French"]')
          expect(@view.$el).not.toContain('.control-group.summary textarea#123-summary-fr[name="summary-fr"][type="text"]:contains("Summary in French")')

        it 'renders value in source locale as help text for each translated attribute', ->
          @view.render()
          $controlGroup = @view.$el.findField('Summary (en)').closest('.control-group')
          expect($controlGroup).toContain('.help-block.source-value:contains("Summary in Japanese")')

        it 'does not value in source locale as help text for value in source locale', ->
          @view.render()
          $controlGroup = @view.$el.findField('Summary (ja)').closest('.control-group')
          expect($controlGroup).not.toContain('.help-block.source-value')

        it 'renders label if label is a value', ->
          @view.render()
          expect(@view.$el).toContain('label[for="123-title-en"]:contains("Title")')

        it 'calls function with locale as argument if label is a function', ->
          @view.render()
          expect(@view.$el).toContain('label[for="123-summary-en"]:contains("Summary (en)")')
          expect(@view.$el).toContain('label[for="123-summary-ja"]:contains("Summary (ja)")')

    describe '#serialize', ->
      it 'throws error if no form tag is found', ->
        @view = new Form(tagName: 'div', model: @model)
        @view.tagName = 'div'
        expect(@view.serialize).toThrow('Serialize must operate on a form element.')

      describe 'untranslated data', ->
        beforeEach ->
          _(@model).extend(
            schema: ->
              attribute1:
                label: 'Attribute1'
                type: 'Text'
              attribute2:
                label: 'Attribute2'
                type: 'TextArea'
          )
          @view = new Form(model: @model)
          @view.cid = '123'
          @view.render()

        it 'serializes form data', ->
          @view.$el.findField('Attribute1').val('a new value')
          @view.$el.findField('Attribute2').val('another new value')
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
              title:
                label: (locale) -> 'Title in ' + (en: 'English', ja: 'Japanese')[locale]
                type: 'Text'
              summary:
                label: (locale) -> 'Summary in ' + (en: 'English', ja: 'Japanese')[locale]
                type: 'TextArea'
          )
          @view = new Form(model: @model, locales: ['en', 'ja'])
          @view.cid = '123'

        it 'serializes translated form data', ->
          @model.set(
            title: new Attribute(en: '', ja: '')
            summary: new Attribute(en: '', ja: '')
          )
          @view.render()
          @view.$el.findField('Title in English').val('a value in English')
          @view.$el.findField('Title in Japanese').val('a value in Japanese')
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
                attribute:
                  label: 'Attribute'
                  type: 'Text'
            @view.render()

          it 'appends error class to control-group for each attribute in errors object', ->
            @view.renderErrors(attribute: 'required')
            $field = @view.$el.findField('Attribute')
            expect($field.closest('.control-group')).toHaveClass('error')

          it 'inserts error msg into help block', ->
            @view.renderErrors(attribute: 'required')
            $field = @view.$el.findField('Attribute')
            expect($field.closest('.controls').find('.help-block')).toHaveText('required')

        describe 'translated (nested) attributes', ->
          beforeEach ->
            _(@model).extend
              schema: ->
                title:
                  label: 'Title'
                  type: 'Text'
            @view.render()

          it 'appends error class to control-group for each attribute in errors object', ->
            @view.renderErrors(title: en: 'required')
            $field = @view.$el.findField('Title')
            expect($field.closest('.control-group')).toHaveClass('error')

          it 'inserts error msg into help block', ->
            @view.renderErrors(title: en: 'required')
            $field = @view.$el.findField('Title')
            expect($field.closest('.controls').find('.help-block')).toHaveText('required')
