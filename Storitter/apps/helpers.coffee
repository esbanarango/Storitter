http = require('http');

site = http.createClient(3000, "localhost");

class Helpers

	@requestAPI: (host, path, method, callback) ->
		data = ""
		request = site.request(method, path, {'host' : host})
		request.end()
		request.on 'response', (res) ->
		  json = '' 		  
		  res.on 'data', (chunk) -> 		  			  	
		    json += chunk
		   res.on 'end', ->
		   	callback JSON.parse(json)

module.exports = Helpers