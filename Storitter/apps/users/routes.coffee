hrlp = require '../Helpers'
User = require '../../models/user'
Post = require '../../models/post'

routes = (app) ->

	app.namespace '/users', ->

		app.get '/:id', (req, res) ->
			console.log "sisas"+req.body
			if req.body.id?
		        console.log "sisas 2"
			    id = req.body.id
			    message = req.body.message
	    		updated_at = req.body.updated_at
	    		console.log id +" "+ message +" "+ updated_at
	    		post = new Post ({id: id, message: message, updated_at: updated_at})
	    		console.log post
	    		if socketIO = app.settings.socketIO	    		
                	socketIO.sockets.emit "user:newMessage", post
                	console.log "Neeea pa ahora siiii dormirme"
			else
		        console.log "nonas"
		    	hrlp.requestAPI "localhost", "/users/#{req.params.id}.json", "GET", (_users) ->
		    		user = new User _users.user
		    		#console.log user
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