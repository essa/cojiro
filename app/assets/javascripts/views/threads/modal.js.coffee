define (require) ->

  _ = require 'underscore'
  ModalView = require 'modules/modal'
  ModalHeaderView = require 'views/modals/header'
  Form = require 'modules/translatable/form'
  ModalFooterView = require 'views/modals/footer'
  I18n = require 'i18n'

  class ThreadModal extends ModalView
    el: '#thread-modal'
    languageSwitcher: _.template '<div id="lang-switcher"><%= editFor %></div>'

    buildEvents: () ->
      _(super).extend
        'submit form': 'submitForm'
        'click button[type="submit"]': 'saveThread'
        'click button[type="cancel"]': 'hideModal'
        'click a': 'changeLocale'

    initialize: (options) ->
      super(options)
      @form = new Form(model: @model)
      @header = new ModalHeaderView(
        title: I18n.t('views.threads.modal.edit_title_and_summary'))
      @footer = new ModalFooterView(
        cancel: I18n.t('views.threads.modal.cancel'),
        submit: I18n.t('views.threads.modal.save')
      )

    render: ->
      @currentLocale ||= I18n.locale
      @renderTemplate()
      @renderHeader()
      @renderForm()
      @renderFooter()
      @

    renderTemplate: -> @$el.html(@template())

    renderHeader: -> @renderChildInto(@header, '.modal-header')

    renderForm: ->
      @form.locales = [ @currentLocale ]
      @renderChildInto(@form, '.modal-body')

    renderFooter: ->
      @renderChildInto(@footer, '.modal-footer')
      otherLocales = _(I18n.availableLocales).difference(@currentLocale)
      languages = _(otherLocales).map (locale) -> "<a lang='#{locale}' class='clickable'>#{I18n.t(locale)}</a>"
      @footer.$el.prepend(@languageSwitcher(
        editFor: I18n.t('views.threads.modal.edit_for', languages: languages)))

    changeLocale: (e) ->
      e.preventDefault()
      @currentLocale = e.currentTarget.getAttribute('lang')
      @render()

    submitForm: (e) -> false

    saveThread: () ->
      view = @
      if @model.set(@form.serialize(), validate: true)
        @model.save {},
          wait: true
          success: (model, resp) ->
            view.hideModal()

    showModal: ->
      @currentLocale = I18n.locale
      super