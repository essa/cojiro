define (require) ->

  _ = require 'underscore'
  ModalView = require 'modules/modal'
  ModalHeaderView = require 'views/modals/header'
  Form = require 'modules/translatable/form'
  ModalFooterView = require 'views/modals/footer'
  I18n = require 'i18n'

  class ThreadHeaderModal extends ModalView
    languageSwitcher: _.template '<div id="lang-switcher"><%= editFor %></div>'

    buildEvents: () ->
      _(super).extend
        'click button[type="submit"]': 'submitForm'

    initialize: (options) ->
      super(options)
      @currentLocale = I18n.locale
      @header = new ModalHeaderView(title: I18n.t('views.threads.header-modal.edit_title_and_summary'))
      @form = new Form(model: @model)
      @footer = new ModalFooterView(cancel: 'Cancel', submit: 'Save')

    render: ->
      @renderTemplate()
      @renderHeader()
      @renderForm()
      @renderFooter()
      @

    renderTemplate: ->
      @$el.html(@template())
      @$el.addClass('header-modal')
    renderHeader: -> @renderChildInto(@header, '.modal-header')
    renderForm: -> @renderChildInto(@form, '.modal-body')

    renderFooter: ->
      @renderChildInto(@footer, '.modal-footer')
      otherLocales = _(I18n.availableLocales).difference(@currentLocale)
      languages = _(otherLocales).map (locale) -> "<a>#{I18n.t(locale)}</a>"
      @footer.$el.prepend(@languageSwitcher(
        editFor: I18n.t('views.threads.header-modal.edit_for', languages: languages)))

    submitForm: ->
      @model.save {}
