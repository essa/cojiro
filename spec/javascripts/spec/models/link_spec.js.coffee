define (require) ->

  I18n = require('i18n')
  Link = require('models/link')
  TranslatableAttribute = require('modules/translatable/attribute')
  sharedExamples = require('spec/models/shared')

  describe 'Link', ->

    sharedExamples(Link, 'link')

    describe 'custom getters', ->
      beforeEach ->
        @link = new Link
        collection = url: '/collection'
        @link.collection = collection
