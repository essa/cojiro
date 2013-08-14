define ['i18n', 'module', 'i18n/translations'], (I18n, module) ->
  # set locale and available locales from module config
  I18n.locale = module.config().locale
  I18n.availableLocales = module.config().availableLocales

  # add method with custom prefix option for templates
  I18n.scoped = (prefix = '') ->
    t: (scope, options) -> I18n.translate.call(I18n, prefix + scope, options)

  I18n
