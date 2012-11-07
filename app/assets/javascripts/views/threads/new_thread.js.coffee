define [
  'jquery'
  'underscore'
  'backbone'
  'backbone-forms'
  'mixins/base_view'
  'app'
  'globals'
  'templates/threads/new'
  'templates/threads/form_actions'
  'templates/other/flash'
], ($, _, Backbone, Form, BaseView, App, globals, newThreadTemplate, formActionsTemplate, flashTemplate) ->

  class NewThreadView extends BaseView
    id: 'new_thread'

    buildEvents: () ->
      _(super).extend
        "submit form" : "submit"

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
            self.collection.add(model, at: 0)
            globals.flash =
              name: "success"
              msg: I18n.t("views.threads.new_thread.thread_created")
            App.appRouter.navigate(model.url(), true )
        )
      else
        @.$('.alert').remove()
        @$el.prepend(flashTemplate(
          name: "error"
          msg: I18n.t("errors.template.body")
        ))
      return false
