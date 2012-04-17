describe "CojiroApp.Collections.Threads", ->
  it "contains instances of CojiroApp.Models.Thread", ->
    collection = new CojiroApp.Collections.Threads()
    expect(collection.model).toEqual(CojiroApp.Models.Thread)

  it "is persisted at /threads", ->
    collection = new CojiroApp.Collections.Threads()
    expect(collection.url).toEqual("/threads")
