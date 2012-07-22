HAML.globals = ->
  edit_button: (text) ->
    if text
    then I18n.t("templates.threads.show.edit")
    else I18n.t("templates.threads.show.add_in", lang: I18n.t(I18n.locale))
