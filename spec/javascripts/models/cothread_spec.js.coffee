# ref: http://blog.bandzarewicz.com/blog/2012/03/08/backbone-dot-js-tdd-with-jasmine-part-one-the-model/
#
describe 'CojiroApp.Models.Cothread', ->
  it 'should be defined', ->
    expect(CojiroApp.Models.Cothread).toBeDefined()

  it 'can be instantiated', ->
    cothread = new CojiroApp.Models.Cothread
    expect(cothread).not.toBeNull()

  describe 'new instance default values', ->
    beforeEach ->
      this.cothread = new CojiroApp.Models.Cothread()

    it 'has default values for the .title attribute', ->
      expect(this.cothread.get('title')).toEqual('')

    it 'has default values for the .summary attribute', ->
      expect(this.cothread.get('summary')).toEqual('')

  describe 'getters', ->
    beforeEach ->
      this.cothread = new CojiroApp.Models.Cothread()

    describe '#getId', ->
      it 'should be defined', ->
        expect(this.cothread.getId).toBeDefined()

      it 'returns undefined if id is not defined', ->
        expect(this.cothread.getId()).toBeUndefined()

      it "otherwise returns model's id", ->
        this.cothread.id = 66;
        expect(this.cothread.getId()).toEqual(66)

    describe '#getTitle', ->
      it 'should be defined', ->
        expect(this.cothread.getTitle).toBeDefined()

      it 'returns value for the title attribute', ->
        stub = sinon.stub(this.cothread, 'get').returns('Thread title')

        expect(this.cothread.getTitle()).toEqual('Thread title')
        expect(stub).toHaveBeenCalledWith('title')

    describe '#getSummary', ->
      it 'should be defined', ->
        expect(this.cothread.getSummary).toBeDefined()

      it 'returns value for the summary attribute', ->
        stub = sinon.stub(this.cothread, 'get').returns('Thread summary')

        expect(this.cothread.getSummary()).toEqual('Thread summary')
        expect(stub).toHaveBeenCalledWith('summary')

    describe '#save', ->
      beforeEach ->
        this.server = sinon.fakeServer.create()

      afterEach ->
        this.server.restore()

      it 'sends valid data to the server', ->
        this.cothread.save({ title: 'Co-working spaces in Tokyo' })
        request = this.server.requests[0]
        params = JSON.parse(request.requestBody)

        expect(params.cothread).toBeDefined()
        expect(params.cothread.title).toEqual('Co-working spaces in Tokyo')

      describe 'request', ->

        describe 'on create', ->
          beforeEach ->
            this.cothread.id = null
            this.cothread.save()
            this.request = this.server.requests[0]

          it 'should be a POST', ->
            expect(this.request.method).toEqual('POST')

          it 'should be async', ->
            expect(this.request.async).toBeTruthy()

          it 'should have a valid URL', ->
            expect(this.request.url).toEqual('/threads.json')

        describe 'on update', ->
          beforeEach ->
            this.cothread.id = 66
            this.cothread.save()
            this.request = this.server.requests[0]

          it 'should be a PUT', ->
            expect(this.request.method).toEqual('PUT')

          it 'should be async', ->
            expect(this.request.async).toBeTruthy()

          it 'should have a valid URL', ->
            expect(this.request.url).toEqual('/threads/66.json')
