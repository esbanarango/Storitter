require('coffee-script');

process.env.NODE_ENV = 'development'; // or 'production' or 'test'

/**
 * Module dependencies.
 */

var express = require('express');

require('express-namespace')

var app = module.exports = express.createServer();

// Configuration
require('./apps/socket-io')(app)

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set('port', 5000);
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(require('connect-assets')());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('test', function () {
  app.set('port', 5001);
});


app.configure('production', function(){
  app.use(express.errorHandler());
});


// Routes
require('./apps/users/routes')(app);
require('./apps/admin/routes')(app);

app.listen(app.settings.port, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
