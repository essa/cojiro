define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base'
  'globals'
  'templates/threads/new'
  'templates/threads/form_actions'
  'templates/other/flash'
  'i18n'
], ($, _, Backbone, Base, globals, newThreadTemplate, formActionsTemplate, flashTemplate, I18n) ->

  class NewThreadView extends Base.View
    id: 'new_thread'

    buildEvents: () ->
      _(super).extend
        "submit form" : "submitForm"

    initialize: (options) ->
      @router = @options.router
      super

    render: ->
      @renderLayout()
      @

    renderLayout: ->
      @$el.html(newThreadTemplate())

    getValue: (field) ->
      @.$("#" + field).val()

    submitForm: () ->
      @model.setAttr("title", @getValue("title"))
      @model.setAttr("summary", @getValue("summary"))
      # TODO: render errors in form
      errors = null
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
