describe "CojiroApp.Collections.Cothreads", ->
  it "contains instances of CojiroApp.Models.Cothread", ->
    collection = new CojiroApp.Collections.Cothreads()
    expect(collection.model).toEqual(CojiroApp.Models.Cothread)

  it "is persisted at /threads", ->
    collection = new CojiroApp.Collections.Cothreads()
    expect(collection.url).toEqual("/cothreads")
