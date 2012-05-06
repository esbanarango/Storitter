#= require jquery-1.7.1.min.js
#= require underscore-min.js

jQuery ->
  # Home page
  console.log window.location.pathname
  if window.location.pathname is '/users/1'

    socket = io.connect("/")
    socket.on "user:newMessage", (data) ->
    	console.log "Neeea pa ahora si del toodo"
