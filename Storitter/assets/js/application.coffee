#= require underscore-min.js

logAlert = (text,layOut,type,timeOut) ->
  noty(
    "text":text,
    "layout":layOut
    "type":type
    "textAlign":"center"
    "easing":"swing"
    "animateOpen":
      "height":
        "toggle"
    "animateClose":
      "height":
        "toggle"
    "speed":"500"
    "timeout":timeOut
    "closable":false
    "closeOnSelfClick":false
    "theme" : 'noty_theme_twitter'
    )

jQuery ->
  # Home page
  userId = $("#userId").val()
  eventOn = "user:newMessage:#{userId}"

  if window.location.pathname is "/users/#{userId}"
    socket = io.connect("/")
    console.log eventOn
    socket.on eventOn, (data) ->
    	html = "<div class='post box'>
  			<p>User id: #{data['id']} #{data['updated_at']}</p>
  			<p>#{data['message']}</p>		
    		</div>"
    	$("#wall").prepend(html)

  $(".login").on "click", ->

    $.ajax '/login'
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, textStatus, errorThrown) ->
          logAlert "Something got wrong... :( sorry!", "topCenter","error","3000"
      success: (data, textStatus, jqXHR) =>
          logAlert "¡Hello!", "topCenter","success","3000"
          $('.follow').slideDown()
          $(@).hide()

  $(document).on "click", ".follow", ->   
    id = $(@).attr 'id'

    $.getJSON "http://localhost:3000/users/#{id}/follow.js?callback=?", (response) =>
      if response.response isnt "error"
        logAlert response.response, "topCenter","success","3000";
        $(@).text "Following now!"
        $(@).off "click"
      else
        logAlert "Something got wrong... :( sorry!. Maybe you're already following that person", "topCenter","error","3000";