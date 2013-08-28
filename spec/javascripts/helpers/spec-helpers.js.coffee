beforeEach ->

  $ = require('jquery')
  Backbone = require('backbone')

  # https://github.com/PaulUithol/Backbone-relational/issues/235
  oldReverseRelations = Backbone.Relational.store._reverseRelations
  Backbone.Relational.store = new Backbone.Store
  Backbone.Relational.store._reverseRelations = oldReverseRelations
  Backbone.Relational.eventQueue = new Backbone.BlockingQueue

  # set locale to default locale
  I18n.locale = I18n.defaultLocale = 'en'
  I18n.availableLocales = ['en', 'ja']

  # unbind all channel events
  channel = require('modules/channel')
  channel.unbind()

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

    # does this element have a field with a given label?
    toHaveField: (labelText) ->
      unless ($el = @actual.find("label:contains('#{labelText}')")).length
        @message = -> "Element has no label '" + labelText + "'"
        return false
      unless (id = $el.attr('for')).length
        @message = -> "Label '" + labelText + "' has no 'for' attribute"
        return false
      @message = -> "Expected to find a field with id '" + id + " but none was found"
      @actual.find('#' + id)?

  # response helpers
  @validResponse = (responseText) ->
    [ 200,
      {"Content-Type":"application/json"},
      JSON.stringify(responseText) ]

  # form helpers
  $.fn.findLabel = (labelText) -> @.find("label:contains(#{labelText})")

  $.fn.findField = (labelText) ->
    (id = @.findLabel(labelText).attr('for')) && @.find('#' + id)

  @createModal = (id) -> $("<div id='#{id}' class='modal hide fade'>")

  # create/destroy sandbox
  @createSandbox = () ->
    $('body').append('<div id="sandbox"></div>')
    $('#sandbox')

  @destroySandbox = () ->
    $('#sandbox').remove()
    $('body .modal-backdrop').remove()
