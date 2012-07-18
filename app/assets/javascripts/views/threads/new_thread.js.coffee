App.NewThreadView = App.Views.NewThread = Support.CompositeView.extend
  id: 'new_thread'

  events:
    "submit form" : "submit"

  initialize: ->
    _.bindAll @

  render: ->
    @renderLayout()
    @renderForm()
    @

  renderLayout: ->
    @$el.html(JST['threads/new'])

  renderForm: ->
    @form = new Backbone.Form(model: @model)
    @form.leave = () ->
      @unbind()
      @remove()
      @parent._removeChild(@)
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
          App.flash =
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
