define (require) ->

  _ = require 'underscore'
  ModalView = require 'modules/modal'
  ModalHeaderView = require 'views/modals/header'
  Form = require 'modules/translatable/form'
  ModalFooterView = require 'views/modals/footer'
  I18n = require 'i18n'

  class ThreadHeaderModal extends ModalView
    el: '#thread-header-modal'
    languageSwitcher: _.template '<div id="lang-switcher"><%= editFor %></div>'

    buildEvents: () ->
      _(super).extend
        'click button[type="submit"]': 'submitForm'
        'click button[type="cancel"]': 'hideModal'
        'click a': 'changeLocale'

    initialize: (options) ->
      super(options)
      @form = new Form(model: @model)
      @footer = new ModalFooterView(
        cancel: I18n.t('views.threads.header-modal.cancel'),
        submit: I18n.t('views.threads.header-modal.save')
      )

    render: ->
      @currentLocale ||= I18n.locale
      @renderTemplate()
      @renderHeader()
      @renderForm()
      @renderFooter()
      @

    renderTemplate: ->
      @$el.html(@template())
      @$el.addClass('header-modal')

    renderHeader: ->
      @header.leave() if @header
      @header = new ModalHeaderView(
        title: I18n.t('views.threads.header-modal.edit_title_and_summary_in_lang', lang: I18n.t(@currentLocale)))
      @renderChildInto(@header, '.modal-header')

    renderForm: ->
      @form.locales = [ @currentLocale ]
      @renderChildInto(@form, '.modal-body')

    renderFooter: ->
      @renderChildInto(@footer, '.modal-footer')
      otherLocales = _(I18n.availableLocales).difference(@currentLocale)
      languages = _(otherLocales).map (locale) -> "<a lang='#{locale}' class='clickable'>#{I18n.t(locale)}</a>"
      @footer.$el.prepend(@languageSwitcher(
        editFor: I18n.t('views.threads.header-modal.edit_for', languages: languages)))

    changeLocale: (e) ->
      e.preventDefault()
      @currentLocale = e.currentTarget.getAttribute('lang')
      @render()

    submitForm: ->
      view = @
      @model.save @form.serialize(),
        success: (model, resp) ->
          view.hideModal()
