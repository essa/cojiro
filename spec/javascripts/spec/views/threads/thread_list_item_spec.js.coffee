define (require) ->

  I18n = require('i18n')
  Thread = require('models/thread')
  Threads = require('collections/threads')
  ThreadListItemView = require('views/threads/thread_list_item')

  describe "ThreadListItemView", ->
    beforeEach ->
      I18n.locale = 'en'
      @thread = new Thread(_(@fixtures.Thread.valid).extend(id: 5))
      @thread.collection = new Threads
      @view = new ThreadListItemView(model: @thread)

    afterEach ->
      I18n.locale = I18n.defaultLocale

    describe "initialization", ->

      it "creates a table row for a thread", ->
        $el = @view.$el
        expect($el).toBe("tr#thread-list-item")
        expect($el).toHaveAttr('data-href', '/en/threads/5')

    describe "rendering", ->

      it "returns the view object", ->
        expect(@view.render()).toEqual(@view)

      it "renders the list item view into the table row", ->
        $el = @view.render().$el
        expect($el.find('td')).toHaveText(/Co-working spaces in Tokyo/)
        expect($el.find('td')).toHaveText(/csasaki/)

      it "renders the update timestamp", ->
        @thread.set('updated_at', "2012-08-22T00:06:21Z")
        $el = $(@view.render().el)
        expect($el.find('time.timeago')).toHaveAttr('datetime', '2012-08-22T00:06:21Z')

      it "attaches a 'new' label if thread was created in the last 24 hours", ->
        @thread.set('created_at', new Date(Date.now() - 10000000).toJSON())
        $el = @view.render().$el
        expect($el).toContain('span.label.label-info')
        expect($el.find('span.label.label-info')).toHaveText("New")

      it "does not attach 'new' label if thread was created more than 24 hours ago", ->
        @thread.set('created_at', new Date(Date.now() - 100000000).toJSON())
        $el = @view.render().$el
        expect($el).not.toContain('span.label.label-info')
