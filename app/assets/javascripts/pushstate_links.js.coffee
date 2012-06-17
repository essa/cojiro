window.document.addEventListener('click', (e) ->
  e = e || window.event
  target = e.target || e.srcElement
  if ( target.nodeName.toLowerCase() == 'a' )
    e.preventDefault()
    uri = target.getAttribute('href')
    App.appRouter.navigate(uri, true)
)

window.addEventListener('popstate', (e) ->
  App.appRouter.navigate(location.pathname, true)
)
