App.NewThreadView = App.Views.NewThread = Support.CompositeView.extend
  id: 'new_thread'

  events:
    "submit form" : "submit"

  initialize: ->
    _.bindAll @

  render: ->
    @renderLayout()
    @renderForm()

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

    @

  submit: () ->
    errors = @form.commit()
    if !(errors?)
      @model.save({},
        success: (model, resp) ->
          view = new App.ThreadView(model: model)
          window.app_router.swap(view)
      )
    return false
