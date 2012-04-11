# ref: http://blog.bandzarewicz.com/blog/2012/03/08/backbone-dot-js-tdd-with-jasmine-part-one-the-model/
#
describe "CojiroApp.Models.Cothread", ->
  it "should be defined", ->
    expect(CojiroApp.Models.Cothread).toBeDefined()

  it "can be instantiated", ->
    cothread = new CojiroApp.Models.Cothread
    expect(cothread).not.toBeNull()

  describe "new instance default values", ->
    beforeEach ->
      this.cothread = new CojiroApp.Models.Cothread()

    it "has default values for the .title attribute", ->
      expect(this.cothread.get("title")).toEqual('')

    it "has default values for the .summary attribute", ->
      expect(this.cothread.get("summary")).toEqual('')

  describe "getters", ->
    describe "#getId", ->
      beforeEach ->
        this.cothread = new CojiroApp.Models.Cothread()

      it "should be defined", ->
        expect(this.cothread.getId).toBeDefined()

      it "returns undefined if id is not defined", ->
        expect(this.cothread.getId()).toBeUndefined()

      it "otherwise returns model's id", ->
        this.cothread.id = 66;
        expect(this.cothread.getId()).toEqual(66)
