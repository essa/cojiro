describe "CojiroApp.Models.Cothread", ->
  it "should be defined", ->
    expect(CojiroApp.Models.Cothread).toBeDefined()

  it "can be instantiated", ->
    cothread = new CojiroApp.Models.Cothread
    expect(cothread).not.toBeNull()
