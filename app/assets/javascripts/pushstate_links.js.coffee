window.document.addEventListener('click', (e) ->
  e = e || window.event
  target = e.target || e.srcElement
  if ( target.nodeName.toLowerCase() == 'a' )
    e.preventDefault()
    uri = target.getAttribute('href')
    window.app_router.navigate(uri, true)
)

window.addEventListener('popstate', (e) ->
  window.app_router.navigate(location.pathname, true)
)
