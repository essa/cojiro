define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/links/register_url'
  'i18n'
], ($, _, Backbone, BaseView, RegisterUrlView, I18n) ->

  class AddLinkModalView extends BaseView
    template: _.template '
        <div class="modal-header">
          <button class="close"
                  type="button"
                  data-dismiss="modal"
                  aria-hidden="true">&times;</button>
          <h3><%= title %></h3>
        </div>
        <div class="modal-body"></div>'

    initialize: (options = {}) ->
      super(options)

      throw('model required') unless options.model
      @step = 0
      @RegisterUrlView = options.RegisterUrlView || RegisterUrlView

    render: () ->
      @modal.leave() if @modal
      switch @step
        when 0
          @$el.html(@template(title: 'Add a link'))
          @modal = new @RegisterUrlView(model: @model)
      @renderChildInto(@modal, '.modal-body')
      @
