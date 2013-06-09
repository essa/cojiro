define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'modules/translatable/form'
  'globals'
  'templates/threads/new'
  'templates/threads/form_actions'
  'templates/other/flash'
  'i18n'
], ($, _, Backbone, Base, Form, globals, newThreadTemplate, formActionsTemplate, flashTemplate, I18n) ->

  class NewThreadView extends Base.View
    id: 'new_thread'

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
      @$el.html(newThreadTemplate())

    renderForm: ->
      @renderChild(@form)
      @$el.append(@form.el)
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
        @form.renderErrors(errors)
        @.$('.alert').remove()
        @$el.prepend(flashTemplate(
          name: "error"
          msg: I18n.t("errors.template.body")
        ))
      return false
