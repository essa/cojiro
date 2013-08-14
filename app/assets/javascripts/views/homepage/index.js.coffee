define [
  'jquery'
  'underscore'
  'backbone'
  'modules/base/view'
  'views/threads/thread_list'
  'views/homepage/thread_filter'
  'globals'
  'i18n'
], ($, _, Backbone, BaseView, ThreadListView, ThreadFilterView, globals, I18n) ->

  class HomepageView extends BaseView
    template: _.template '
      <% if (!currentUser) { %>
        <section class="hero-unit">
          <h1><%= t(".catchphrase") %></h1>
          <%= t(".lead_html", { url: "#" }) %>
        </section>
      <% } %>
      <section class="latest">
        <div id="content-header">
          <% if (!currentUser) { %>
            <h3>
              <%= t(".recent_threads") %>
              <small>
                <%= t(".invite_message_html", { new_account_url: "#", login_url: "#" }) %>
              </small>
            </h3>
          <% } %>
        </div>
      </section>
      <div id="threads"></div>
    '
    id: 'homepage'

    initialize: (options = {}) ->
      # isolate dependencies
      @ThreadListView = options.ThreadListView || ThreadListView
      @ThreadFilterView = options.ThreadFilterView || ThreadFilterView

      # initialize view
      @filteredCollection = @collection
      @collection.bind("change", @renderThreadList)

    render: ->
      @renderLayout()
      if globals.currentUser?
        @renderThreadFilter()
      @renderThreadList()
      @

    renderLayout: ->
      @$el.html(@template(
        t: I18n.scoped('views.homepage.index').t
        currentUser: globals.currentUser
      ))

    renderThreadList: =>
      @threadListView = new @ThreadListView(collection: @filteredCollection)
      threadListContainer = @.$('#threads')
      @renderChildInto(@threadListView, threadListContainer)

    renderThreadFilter: =>
      @threadFilterView = new @ThreadFilterView
      @threadFilterView.bind("changed", @filterThreads)
      threadFilterContainer = @.$('#content-header')
      @renderChildInto(@threadFilterView, threadFilterContainer)

    filterThreads: (scope) =>
      switch(scope)
        when "all"
          @filteredCollection = @collection
          @renderThreadList()
        when "mine"
          @filteredCollection = @collection.byUser(globals.currentUser.name)
          @renderThreadList()
