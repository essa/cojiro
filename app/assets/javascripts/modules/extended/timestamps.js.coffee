define [
  'i18n'
], (I18n) ->

  class Timestamps
    getCreatedAt: -> @toDateStr(@get('created_at'))
    getUpdatedAt: -> @toDateStr(@get('updated_at'))

    toDateStr: (datetime) ->
      I18n.l('date.formats.long', datetime) unless datetime is undefined
