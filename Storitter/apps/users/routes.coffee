hrlp = require '../Helpers'


routes = (app) ->

	app.namespace '/users', ->

		app.get '/', (req, res) ->
			hrlp.requestAPI "localhost", "/users.json", "GET", (users) ->
				res.render "#{__dirname}/views/all",
	            	title: 'View All Pies'
	            	users: JSON.stringify(users)



module.exports = routes