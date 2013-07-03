beforeEach ->

  Backbone = require('backbone')

  # https://github.com/PaulUithol/Backbone-relational/issues/235
  oldReverseRelations = Backbone.Relational.store._reverseRelations
  Backbone.Relational.store = new Backbone.Store
  Backbone.Relational.store._reverseRelations = oldReverseRelations
  Backbone.Relational.eventQueue = new Backbone.BlockingQueue

  # set locale to default locale
  I18n.locale = I18n.defaultLocale

  @addMatchers

    # request matchers
    toBeGET: -> @actual.method is 'GET'
    toBePOST: -> @actual.method is 'POST'
    toBePUT: -> @actual.method is 'PUT'
    toHaveUrl: (expected) ->
      actual = @actual.url
      @message = -> "Expected request to have url " + expected + " but was " + actual
      actual is expected
    toBeAsync: -> @actual.async

    # Backbone custom matchers
    toHaveMany: (key) -> @actual.get(key) instanceof Backbone.Collection

  # response helpers
  @validResponse = (responseText) ->
    [ 200,
      {"Content-Type":"application/json"},
      JSON.stringify(responseText) ]
