define [
  'jquery'
  'bootstrap-tooltip'
], ($) ->
  # ref: http://stackoverflow.com/questions/14694930/callback-function-after-tooltip-popover-is-created-with-twitter-bootstrap
  tmp = $.fn.tooltip.Constructor::show
  $.fn.tooltip.Constructor::show = () ->
    tmp.call(@)
    if (@options.callback)
      @options.callback()
