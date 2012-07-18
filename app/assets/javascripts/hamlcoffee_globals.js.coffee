HAML.globals = ->
  renderTranslatedAttr: (model, attr_name) ->
    model.get(attr_name) || ('<span class="untranslated">' + model.getAttrInSourceLocale(attr_name) + '</span>')
  edit_button: (text) ->
    if text
    then I18n.t("templates.threads.show.edit")
    else I18n.t("templates.threads.show.add_in", lang: I18n.t(I18n.locale))
