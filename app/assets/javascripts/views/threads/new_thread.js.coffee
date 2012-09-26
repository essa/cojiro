define [
  'jquery',
  'underscore',
  'backbone',
  'mixins/base_view',
  'app',
  'globals',
  'mixins/composite_form',
  'templates/threads/new',
  'templates/threads/form_actions',
  'templates/other/flash'
], ($, _, Backbone, BaseView, App, globals) ->

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
      @$el.html(JST['threads/new'])

    renderForm: ->
      @form = new Backbone.CompositeForm(model: @model)
      @renderChild(@form)
      @$el.append(@form.el)
      @.$('fieldset').append(JST['threads/form_actions'])

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
        @$el.prepend(JST['other/flash'](
          name: "error"
          msg: I18n.t("errors.template.body")
        ))
      return false
