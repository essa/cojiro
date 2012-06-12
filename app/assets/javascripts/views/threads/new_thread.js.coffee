App.NewThreadView = App.Views.NewThread = Support.CompositeView.extend
  id: 'new_thread'

  initialize: ->
    _.bindAll @

  render: ->
    @renderLayout()
    @renderForm()

  renderLayout: ->
    @$el.html(JST['threads/new'])

  renderForm: ->
    formContainer = @.$('form')
    formContainer.html('')

    formView = new Backbone.Form(model: @model)
    @renderChild(formView)
    formContainer.append(formView.el)

    @
