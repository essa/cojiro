define ['jquery', 'underscore', 'i18n', 'jquery.timeago'], ($, _, I18n) ->

  getStrings = ->
    strings = {}
    _([
      'prefixAgo'
      'prefixFromNow'
      'suffixAgo'
      'suffixFromNow'
      'seconds'
      'minute'
      'minutes'
      'hour'
      'hours'
      'day'
      'days'
      'month'
      'months'
      'year'
      'years'
      'wordSeparator'
    ]).each (key) -> strings[key] = I18n.t("jquery.timeago.#{key}")
    strings['numbers'] = []
    strings

  inWords = $.timeago.inWords
  settings = $.timeago.settings

  $.extend($.timeago,
    inWords: (distanceMillis) ->
      settings.strings = getStrings()
      inWords.call($.timeago, distanceMillis)
  )
  $.timeago
