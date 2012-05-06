#= require jquery-1.7.1.min.js
#= require underscore-min.js

jQuery ->
  # Home page
  userId = $("#userId").val()
  eventOn = "user:newMessage:#{userId}"
  socket = io.connect("/")
  console.log eventOn
  socket.on eventOn, (data) ->
  	html = "<div class='post box'>
			<p>User id: #{data['id']} #{data['updated_at']}</p>
			<p>#{data['message']}</p>		
  		</div>"
  	$("#wall").prepend(html)
