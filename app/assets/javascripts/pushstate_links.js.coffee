window.document.addEventListener('click', (e) ->
  e = e || window.event
  target = e.target || e.srcElement
  if ( target.nodeName.toLowerCase() == 'a' )
    e.preventDefault()
    uri = target.getAttribute('href')
    window.app_router.navigate(uri.substr(1), true)
)

window.addEventListener('popstate', (e) ->
  window.app_router.navigate(location.pathname.substr(1), true)
)
