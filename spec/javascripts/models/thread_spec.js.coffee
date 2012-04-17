# ref: http://blog.bandzarewicz.com/blog/2012/03/08/backbone-dot-js-tdd-with-jasmine-part-one-the-model/
#
describe 'CojiroApp.Models.Thread', ->
  it 'is defined', -> expect(CojiroApp.Models.Thread).toBeDefined()

  it 'can be instantiated', ->
    thread = new CojiroApp.Models.Thread
    expect(thread).not.toBeNull()

  describe 'new instance default values', ->
    beforeEach -> @thread = new CojiroApp.Models.Thread()

    it 'has default values for the .title attribute', ->
      expect(@thread.get('title')).toEqual('')

    it 'has default values for the .summary attribute', ->
      expect(@thread.get('summary')).toEqual('')

  describe 'getters', ->
    beforeEach -> @thread = new CojiroApp.Models.Thread()

    describe '#getId', ->
      it 'is defined', -> expect(@thread.getId).toBeDefined()

      it 'returns undefined if id is not defined', ->
        expect(@thread.getId()).toBeUndefined()

      it "otherwise returns model's id", ->
        @thread.id = 66;
        expect(@thread.getId()).toEqual(66)

    describe '#getTitle', ->
      it 'is defined', -> expect(@thread.getTitle).toBeDefined()

      it 'returns value for the title attribute', ->
        stub = sinon.stub(@thread, 'get').returns('Thread title')

        expect(@thread.getTitle()).toEqual('Thread title')
        expect(stub).toHaveBeenCalledWith('title')

    describe '#getSummary', ->
      it 'is defined', -> expect(@thread.getSummary).toBeDefined()

      it 'returns value for the summary attribute', ->
        stub = sinon.stub(@thread, 'get').returns('Thread summary')

        expect(@thread.getSummary()).toEqual('Thread summary')
        expect(stub).toHaveBeenCalledWith('summary')

    describe '#save', ->
      beforeEach -> @server = sinon.fakeServer.create()
      afterEach -> @server.restore()

      it 'sends valid data to the server', ->
        @thread.save({ title: 'Co-working spaces in Tokyo' })
        request = @server.requests[0]
        params = JSON.parse(request.requestBody)

        expect(params.thread).toBeDefined()
        expect(params.thread.title).toEqual('Co-working spaces in Tokyo')

      describe 'request', ->

        describe 'on create', ->
          beforeEach ->
            @thread.id = null
            @thread.save()
            @request = @server.requests[0]

          it 'is a POST', -> expect(@request).toBePOST()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/threads')

        describe 'on update', ->
          beforeEach ->
            @thread.id = 66
            @thread.save()
            @request = @server.requests[0]

          it 'is a PUT', -> expect(@request).toBePUT()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/threads/66')
