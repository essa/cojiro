# ref1: http://blog.bandzarewicz.com/blog/2012/03/08/backbone-dot-js-tdd-with-jasmine-part-one-the-model/
# ref2: http://tinnedfruit.com/2011/03/25/testing-backbone-apps-with-jasmine-sinon-2.html
describe 'CojiroApp.Models.Thread', ->
  beforeEach -> I18n.locale = 'en'

  it 'is defined', -> expect(CojiroApp.Models.Thread).toBeDefined()

  it 'can be instantiated', ->
    thread = new CojiroApp.Models.Thread
    expect(thread).not.toBeNull()

  describe 'new instance default values', ->
    beforeEach -> @thread = new CojiroApp.Models.Thread()

    it 'has default value for the .title attribute', ->
      expect(@thread.get('title')).toEqual('')

    it 'has default value for the .summary attribute', ->
      expect(@thread.get('summary')).toEqual('')

    it 'has default value for the .created_at attribute', ->
      expect(@thread.get('created_at')).toEqual('')

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

    describe '#getCreatedAt', ->
      it 'is defined', -> expect(@thread.getCreatedAt).toBeDefined()

      it 'returns value for the created_at attribute', ->
        stub = sinon.stub(@thread, 'get').returns('2012-04-20T00:52:29Z')

        expect(@thread.getCreatedAt()).toEqual('2012-04-20T00:52:29Z')
        expect(stub).toHaveBeenCalledWith('created_at')

    describe '#url', ->
      it 'returns collection URL when id is not set', ->
        expect(@thread.url()).toEqual('/en/threads')

      it 'returns collection URL and id when id is set', ->
        @thread.id = 66
        expect(@thread.url()).toEqual('/en/threads/66')

      it 'incorporates locale into the URL', ->
        I18n.locale = 'ja'
        expect(@thread.url()).toEqual('/ja/threads')
        @thread.id = 66
        expect(@thread.url()).toEqual('/ja/threads/66')

    describe '#save', ->
      beforeEach -> @server = sinon.fakeServer.create()
      afterEach -> @server.restore()

      it 'sends valid data to the server', ->
        @thread.save
          title: 'Co-working spaces in Tokyo',
          summary: 'I\'m collecting blog posts on co-working spaces in Tokyo.'
          created_at: '2012-04-20T00:52:29Z'
        request = @server.requests[0]
        params = JSON.parse(request.requestBody)

        expect(params.thread).toBeDefined()
        expect(params.thread.title).toEqual('Co-working spaces in Tokyo')
        expect(params.thread.summary).toEqual('I\'m collecting blog posts on co-working spaces in Tokyo.')
        expect(params.thread.created_at).toEqual('2012-04-20T00:52:29Z')

      describe 'request', ->

        describe 'on create', ->
          beforeEach ->
            @thread.id = null
            @thread.save()
            @request = @server.requests[0]

          it 'is a POST', -> expect(@request).toBePOST()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/en/threads')

        describe 'on update', ->
          beforeEach ->
            @thread.id = 66
            @thread.save()
            @request = @server.requests[0]

          it 'is a PUT', -> expect(@request).toBePUT()
          it 'is async', -> expect(@request).toBeAsync()
          it 'has a valid URL', -> expect(@request).toHaveUrl('/en/threads/66')

      describe 'validations', ->

        it 'does not save if the title is blank', ->
          eventSpy = sinon.spy()
          @thread.bind('error', eventSpy)
          @thread.save("title":"")
          expect(eventSpy).toHaveBeenCalledOnce()
          expect(eventSpy).toHaveBeenCalledWith(@thread,"cannot have an empty title")
