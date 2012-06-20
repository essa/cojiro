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
            msg: "Thread successfully created."
          App.appRouter.navigate(model.url(), true )
      )
    else
      @.$('.alert').remove()
      @$el.prepend(JST['other/flash'](
        name: "error"
        msg: "There were errors in the information entered."
      ))
    return false
