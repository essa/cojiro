define (require) ->
  Array::rotate = (n) -> @slice(n, this.length).concat(this.slice(0, n))
  Array
