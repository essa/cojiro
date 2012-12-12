beforeEach ->

  # request matchers
  @addMatchers
    toBeGET: -> @actual.method is 'GET'
    toBePOST: -> @actual.method is 'POST'
    toBePUT: -> @actual.method is 'PUT'
    toHaveUrl: (expected) ->
      actual = @actual.url
      @message = -> "Expected request to have url " + expected + " but was " + actual
      actual is expected
    toBeAsync: -> @actual.async

  # response helpers
  @validResponse = (responseText) ->
    [ 200,
      {"Content-Type":"application/json"},
     JSON.stringify(responseText) ]
