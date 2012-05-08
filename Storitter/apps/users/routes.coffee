hrlp = require '../Helpers'
User = require '../../models/user'
Post = require '../../models/post'

routes = (app) ->

	app.namespace '/users', ->

		app.get '/newMessage', (req, res) ->

		    id = req.query["id"]
		    message = req.query["message"]
	    	updated_at = req.query["updated_at"]
	    	post = new Post ({id: id, message: message, updated_at: updated_at})
	    	respToServer = ""
	    	if socketIO = app.settings.socketIO
	    		socketIO.sockets.emit "user:newMessage:#{id}", post
	    		console.log "New Message"
	    		respToServer = "Ok"
	    	else
	    		respToServer = "Error"
	    	res.header("Content-Type","application/json")
	    	res.json({response: respToServer})
	    	res.end()

		app.get '/:id', (req, res) ->

			hrlp.requestAPI "localhost", "/users/#{req.params.id}.json", "GET", (_users) ->
				user = new User _users.user
				res.render "#{__dirname}/views/me",
					title: "User #{user.username}"
					user: user

		app.get '/', (req, res) ->
			hrlp.requestAPI "localhost", "/users.json", "GET", (_users) ->
				users = []
				for key, value  of _users
				    for usr in value
					    user = new User usr
					    users.push user
				res.render "#{__dirname}/views/all",
					   title: 'Storitter Users'						
					   users: users

	    
module.exports = routes