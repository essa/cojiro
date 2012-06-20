window.document.addEventListener('click', (e) ->
  e = e || window.event
  target = e.target || e.srcElement
  if ( target.nodeName.toLowerCase() == 'a' )
    uri = target.getAttribute('href')
    if !(uri.match(/logout|auth\/twitter|\#close/))
      e.preventDefault()
      App.appRouter.navigate(uri, true)
)

window.addEventListener('popstate', (e) ->
  App.appRouter.navigate(location.pathname, true)
)
