define ['i18n', 'module', 'i18n/translations'], (I18n, module) ->
  I18n.locale = module.config().locale
  I18n.default_locale = module.config().default_locale
  return I18n
