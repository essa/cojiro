define ['i18n', 'module', 'i18n/translations'], (I18n, module) ->
  # set locale and available locales from module config
  I18n.locale = module.config().locale
  I18n.availableLocales = module.config().availableLocales

  # add method with custom prefix option for templates
  I18n.scoped = (prefix = '') ->
    t: (scope, options) -> I18n.translate.call(I18n, prefix + scope, options)

  # add withLocale method
  I18n.withLocale = (locale, callback) ->
    originalLocale = I18n.locale
    I18n.locale = locale
    ret = callback()
    I18n.locale = originalLocale
    ret

  # get the locale in that language, e.g. 'ja' -> '日本語'
  I18n.localeInWords = (locale) -> I18n.withLocale(locale, () -> I18n.t(locale))

  I18n
