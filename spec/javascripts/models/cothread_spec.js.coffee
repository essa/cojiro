# ref: http://blog.bandzarewicz.com/blog/2012/03/08/backbone-dot-js-tdd-with-jasmine-part-one-the-model/
#
describe 'CojiroApp.Models.Cothread', ->
  it 'is defined', -> expect(CojiroApp.Models.Cothread).toBeDefined()

  it 'can be instantiated', ->
    cothread = new CojiroApp.Models.Cothread
    expect(cothread).not.toBeNull()

  describe 'new instance default values', ->
    beforeEach -> @cothread = new CojiroApp.Models.Cothread()

    it 'has default values for the .title attribute', ->
      expect(@cothread.get('title')).toEqual('')

    it 'has default values for the .summary attribute', ->
      expect(@cothread.get('summary')).toEqual('')

  describe 'getters', ->
    beforeEach -> @cothread = new CojiroApp.Models.Cothread()

    describe '#getId', ->
      it 'is defined', -> expect(@cothread.getId).toBeDefined()

      it 'returns undefined if id is not defined', ->
        expect(@cothread.getId()).toBeUndefined()

      it "otherwise returns model's id", ->
        @cothread.id = 66;
        expect(@cothread.getId()).toEqual(66)

    describe '#getTitle', ->
      it 'is defined', -> expect(@cothread.getTitle).toBeDefined()

      it 'returns value for the title attribute', ->
        stub = sinon.stub(@cothread, 'get').returns('Thread title')

        expect(@cothread.getTitle()).toEqual('Thread title')
        expect(stub).toHaveBeenCalledWith('title')

    describe '#getSummary', ->
      it 'is defined', -> expect(@cothread.getSummary).toBeDefined()

      it 'returns value for the summary attribute', ->
        stub = sinon.stub(@cothread, 'get').returns('Thread summary')

        expect(@cothread.getSummary()).toEqual('Thread summary')
        expect(stub).toHaveBeenCalledWith('summary')

    describe '#save', ->
      beforeEach -> @server = sinon.fakeServer.create()
      afterEach -> @server.restore()

      it 'sends valid data to the server', ->
        @cothread.save({ title: 'Co-working spaces in Tokyo' })
        request = @server.requests[0]
        params = JSON.parse(request.requestBody)

        expect(params.cothread).toBeDefined()
        expect(params.cothread.title).toEqual('Co-working spaces in Tokyo')

      describe 'request', ->

        describe 'on create', ->
          beforeEach ->
            @cothread.id = null
            @cothread.save()
            @request = @server.requests[0]

          it 'is a POST', -> expect(@request).toBePOST()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/threads.json')

        describe 'on update', ->
          beforeEach ->
            @cothread.id = 66
            @cothread.save()
            @request = @server.requests[0]

          it 'is a PUT', -> expect(@request).toBePUT()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/threads/66.json')
