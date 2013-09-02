define (require) ->

  _ = require('underscore')
  I18n = require('i18n')
  module = require('module')
  require('i18n/translations')
  require('modules/extended/array')

  # set locale and available locales from module config
  I18n.locale = module.config().locale
  I18n.availableLocales = module.config().availableLocales

  I18n.changeLocale = (locale) ->
    index = _(@availableLocales).indexOf(locale)
    @availableLocales = @availableLocales.rotate(index)
    I18n.locale = locale

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
