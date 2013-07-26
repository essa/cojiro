define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'modules/translatable/form'
  'globals'
  'templates/threads/form_actions'
  'templates/other/flash'
  'i18n'
], ($, _, Backbone, BaseView, Form, globals, formActionsTemplate, flashTemplate, I18n) ->

  class NewThreadView extends BaseView
    id: 'new_thread'
    template: _.template '
      <div class="page-header">
        <h1><%= start_a_thread_string %></h1>
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
      self = @
      start_a_thread_string = I18n.t('templates.threads.new.start_a_thread')
      @$el.html(self.template(start_a_thread_string: start_a_thread_string))

    renderForm: ->
      @appendChild(@form)
      @.$('fieldset').append(formActionsTemplate())

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
              msg: I18n.t("views.threads.new_thread.thread_created")
            self.router.navigate(model.url(), true )
        )
      else
        @.$('.alert').remove()
        @$el.prepend(flashTemplate(
          name: "error"
          msg: I18n.t("errors.template.body")
        ))
      return false
