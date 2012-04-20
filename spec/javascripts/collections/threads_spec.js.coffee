describe "CojiroApp.Collections.Threads", ->

  it "contains instances of CojiroApp.Models.Thread", ->
    collection = new CojiroApp.Collections.Threads()
    expect(collection.model).toEqual(CojiroApp.Models.Thread)

  it "is persisted at /en/threads for an English locale", ->
    I18n.locale = 'en'
    collection = new CojiroApp.Collections.Threads()
    expect(collection.url()).toEqual("/en/threads")

  it "is persisted at /ja/threads for a Japanese locale", ->
    I18n.locale = 'ja'
    collection = new CojiroApp.Collections.Threads()
    expect(collection.url()).toEqual("/ja/threads")
