define [
  'jquery'
  'underscore'
  'backbone'
  'models/link'
  'modules/base/view'
  'modules/translatable'
  'globals'
], ($, _, Backbone, Link, BaseView, Translatable, globals) ->

  class LinkView extends BaseView
    className: 'link'
    template: _.template '
        <div class="link-inner">
          <div class="url">
            <a href="<%= model.getUrl() %>">
              <span class="lang"><%= model.getSourceLocale() %></span>
              <span class="site"><%= model.getSiteName() %></span>
            </a>
            <a href="#" style="float: right" class="icon-edit" />
          </div>
          <a class="description">
            <h3 class="title"></h3>
            <p class="summary"></p>
          </a>
        </div>'

    initialize: ->
      @titleField = new Translatable.InPlaceField(model: @model, field: 'title', editable: globals.currentUser?)
      @summaryField = new Translatable.InPlaceField(model: @model, field: 'summary', editable: globals.currentUser?)
      super

    render: ->
      @$el.html(@template(model: @model))
      @renderTranslatableFields()
      @

    renderTranslatableFields: ->
      @renderChildInto(@titleField, '.title')
      @renderChildInto(@summaryField, '.summary')
