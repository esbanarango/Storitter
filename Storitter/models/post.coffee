_              = require 'underscore'

class Post

  constructor: (attributes) ->
    @[key] = value for key,value of attributes
    @

module.exports = Post