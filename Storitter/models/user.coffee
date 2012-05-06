_              = require 'underscore'

class User

  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @

module.exports = User