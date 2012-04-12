beforeEach ->
  this.addMatchers
    toBeGET: -> this.actual.method == 'GET'
    toBePOST: -> this.actual.method == 'POST'
    toBePUT: -> this.actual.method == 'PUT'
    toHaveUrl: (expected) ->
      actual = this.actual.url
      this.message = -> "Expected request to have url " + expected + " but was " + actual
    toBeAsync: -> this.actual.async
