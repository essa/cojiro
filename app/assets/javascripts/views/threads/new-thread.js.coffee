define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'modules/translatable/form'
  'views/other/form-actions'
  'globals'
  'i18n'
], ($, _, Backbone, BaseView, Form, FormActionsView, globals, I18n) ->

  class NewThreadView extends BaseView
    id: 'new-thread'
    template: _.template '
      <div class="page-header">
        <h1><%= t(".start_a_thread") %></h1>
      </div>'

    buildEvents: () ->
      _(super).extend
        "submit form" : "submitForm"

    initialize: (options) ->
      @router = @options.router
      @form = new Form(model: @model)
      super

    render: ->
      @renderLayout()
      @renderForm()
      @

    renderLayout: ->
      @$el.html(@template(t: I18n.scoped('views.threads.new-thread').t))

    renderForm: ->
      @appendChild(@form)
      @formActions = new FormActionsView(
        submit: I18n.t('views.threads.new-thread.submit')
        cancel: I18n.t('views.threads.new-thread.cancel')
      )
      @appendChildTo(@formActions, 'fieldset')

    submitForm: () ->
      @model.set(@form.serialize(), validate: true)
      if !(errors = @model.validationError)
        self = @
        @model.save({},
          success: (model, resp) ->
            I18n = require('i18n')
            self.collection.add(model, at: 0)
            globals.flash =
              name: "success"
              msg: I18n.t("views.threads.new-thread.thread_created")
            self.router.navigate(model.url(), true )
        )
      return false
