hrlp = require '../Helpers'
User = require '../../models/user'

routes = (app) ->

	app.namespace '/users', ->

		app.get '/', (req, res) ->
			hrlp.requestAPI "localhost", "/users.json", "GET", (_users) ->
				users = []
				for key, value  of _users
					for usr in value
		    			user = new User usr
		    			users.push user
				res.render "#{__dirname}/views/all",
	            	title: 'View All Pies'
	            	users: users

	    #app.put '/:id', (req, res) ->
	    #	Pie.getById req.params.id, (err, pie) ->

module.exports = routes