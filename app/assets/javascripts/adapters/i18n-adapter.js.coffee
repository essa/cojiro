define ['i18n', 'module', 'i18n/translations'], (I18n, module) ->
  I18n.locale = module.config().locale
  I18n.availableLocales = module.config().availableLocales
  return I18n
