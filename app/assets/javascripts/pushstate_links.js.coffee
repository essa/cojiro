window.document.addEventListener('click', (e) ->
  e = e || window.event
  target = e.target || e.srcElement
  if ( target.nodeName.toLowerCase() == 'a' )
    e.preventDefault()
    uri = target.getAttribute('href')
    window.appRouter.navigate(uri, true)
)

window.addEventListener('popstate', (e) ->
  window.appRouter.navigate(location.pathname, true)
)
