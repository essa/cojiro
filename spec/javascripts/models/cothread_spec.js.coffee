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
