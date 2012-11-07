define [
  'backbone'
  'backbone-forms'
], (Backbone) ->

  # cleans up using backbone-support approach
  Backbone.CompositeForm = (options) ->
    Backbone.Form.apply(@, [options])

  _.extend Backbone.CompositeForm.prototype, Backbone.Form.prototype,

    leave: () ->
      @unbind()
      @remove()
      @parent._removeChild(@)

  Backbone.CompositeForm.extend = Backbone.Form.extend

  # define custom form template
  Backbone.Form.setTemplates
    form: "<form class=\"form-horizontal\">{{fieldsets}}</form>"
    fieldset: "<fieldset><legend>{{legend}}</legend>{{fields}}</fieldset>"
    field: "<div class=\"control-group\"><label class=\"control-label\" for=\"{{id}}\">{{title}}</label>        <div class=\"controls\"><div class=\"input-xlarge\">{{editor}}</div><div class=\"help-block\">{{help}}</div></div></div>"
    nestedField: "<div><div title=\"{{title}}\" class=\"input-xlarge\">{{editor}}</div><div class=\"help-block\">{{help}}</div></div>"
    list: "<div class=\"bbf-list\"><ul class=\"unstyled clearfix\">{{items}}</ul><button class=\"btn bbf-add\" data-action=\"add\">Add</div></div>"
    listItem: "<li class=\"clearfix\"><div class=\"pull-left\">{{editor}}</div><button class=\"btn bbf-del\" data-action=\"remove\">x</button></li>"
    date: "<div class=\"bbf-date\"><select data-type=\"date\" class=\"bbf-date\">{{dates}}</select><select data-type=\"month\" class=\"bbf-month\">{{months}}</select><select data-type=\"year\" class=\"bbf-year\">{{years}}</select></div>"
    dateTime: "<div class=\"bbf-datetime\"><p>{{date}}</p><p><select data-type=\"hour\" style=\"width: 4em\">{{hours}}</select>:<select data-type=\"min\" style=\"width: 4em\">{{mins}}</select></p></div>"
    "list.Modal": "<div class=\"bbf-list-modal\">{{summary}}</div>"

    inPlaceForm: "<form class=\"form-inline in-place-form\">{{fieldsets}}</form>"
    inPlaceFieldset: "<fieldset class=\"in-place-form\">{{fields}}</fieldset>"
    inPlaceField: "<span class=\"input-small\">{{editor}}</span>"
  ,
    error: "error"

  return Backbone.CompositeForm 
