App.NewThreadView = App.Views.NewThread = Support.CompositeView.extend
  id: 'new_thread'

  events:
    "click .btn" : "submit"

  initialize: ->
    _.bindAll @

  render: ->
    @renderLayout()
    @renderForm()

  renderLayout: ->
    @$el.html(JST['threads/new'])

  renderForm: ->
    @form = new Backbone.Form(model: @model)
    @renderChild(@form)
    @$el.append(@form.el)
    @.$('fieldset').append(JST['threads/form_actions'])

    @

  submit: (e) ->
    e.preventDefault()
    errors = @form.commit()
    if !(errors?)
      @model.save()
