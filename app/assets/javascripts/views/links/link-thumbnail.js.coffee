define [
  'underscore'
  'modules/base/view'
], (_, BaseView) ->

  class LinkThumbnailView extends BaseView
    template: _.template '<img src="<%= thumbnailUrl %>" />'

    render: -> @$el.html(@template(thumbnailUrl: @model.getThumbnailUrl()))
