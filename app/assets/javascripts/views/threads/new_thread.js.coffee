define [
  'jquery'
  'underscore'
  'backbone'
  'backbone-forms'
  'modules/base'
  'globals'
  'templates/threads/new'
  'templates/threads/form_actions'
  'templates/other/flash'
  'i18n'
], ($, _, Backbone, Form, Base, globals, newThreadTemplate, formActionsTemplate, flashTemplate, I18n) ->

  class NewThreadView extends Base.View
    id: 'new_thread'

    buildEvents: () ->
      _(super).extend
        "submit form" : "submit"

    initialize: (options) ->
      @router = @options.router
      super

    render: ->
      @renderLayout()
      @renderForm()
      @

    renderLayout: ->
      @$el.html(newThreadTemplate())

    renderForm: ->
      @form = new Form(model: @model)
      @renderChild(@form)
      @$el.append(@form.el)
      @.$('fieldset').append(formActionsTemplate())

    submit: () ->
      errors = @form.commit()
      if !(errors?)
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
