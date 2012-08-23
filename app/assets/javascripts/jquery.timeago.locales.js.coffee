$ ->
  strings = {}
  _([
    "prefixAgo",
    "prefixFromNow",
    "suffixAgo",
    "suffixFromNow",
    "seconds",
    "minute",
    "minutes",
    "hour",
    "hours",
    "day",
    "days",
    "month",
    "months",
    "year",
    "years",
    "wordSeparator"
  ]).each (key) -> strings[key] = I18n.t("jquery.timeago.#{key}")
  strings["numbers"] = []
  $.timeago.settings.strings = strings
