describe "App.TranslatableFieldsModel", ->

  describe 'getters', ->
    beforeEach ->
      @model = new App.TranslatableFieldsModel
      @model.collection = url: '/collection'

    describe '#getAttrInSourceLocale', ->
      it 'is defined', -> expect(@model.getAttrInSourceLocale).toBeDefined()

      it 'returns value for the attr_in_source_locale helper method', ->
        stub = sinon.stub(@model, 'get').returns('Attribute in source language')

        expect(@model.getAttrInSourceLocale('attribute')).toEqual('Attribute in source language')
        expect(stub).toHaveBeenCalledWith('attribute_in_source_locale')

    describe '#getSourceLocale', ->
      it 'is defined', -> expect(@model.getSourceLocale).toBeDefined()

      it 'returns value for the source_locale attribute', ->
        stub = sinon.stub(@model, 'get').returns('ja')

        expect(@model.getSourceLocale()).toEqual('ja')
        expect(stub).toHaveBeenCalledWith('source_locale')

    describe "validations", ->
      beforeEach ->
        @spy = sinon.spy()
        @model.bind('error', @spy)

      it 'does not save if the source locale is blank', ->
        @model.save('source_locale': "")
        expect(@spy).toHaveBeenCalledOnce()
        expect(@spy).toHaveBeenCalledWith(@model,{'source_locale':"can't be blank"})

      it 'does not save if the source locale is null', ->
        @model.save('source_locale': null)
        expect(@spy).toHaveBeenCalledOnce()
        expect(@spy).toHaveBeenCalledWith(@model,{'source_locale':"can't be blank"})
