# pageReloadedEvent is delegating events "document:ready" and "page:load"
pageReloadedEvent = new CustomEvent('page:reloaded');

$ ->
  $(document).on 'page:load', ->
    document.dispatchEvent pageReloadedEvent
  document.dispatchEvent pageReloadedEvent

# Animated page transitions
# From https://coderwall.com/p/t5ghhw
$(document).on 'page:change', ->
  $('#content').addClass 'animated fadeIn'

$(document).on 'page:fetch', ->
  $('#content').addClass += 'animated fadeOut'
