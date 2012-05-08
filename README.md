Storitter
=========

###Description
Simple _project_ to get familiar with technologies used at Storific.

#####Requirements
>"Imagine that you were at Twitter headquarters few years ago and it has been decided to use Ruby on Rails to develop the twitter API.
>User interface and admin interface are totally independent from the rails API, so no need views or assets."

##


## Install and run it!
To run it you just need to follow the steps below.

First clone the repo into your machine, `$ git clone git@github.com:esbanarango/Storitter.git`, this will create a folder, _Storitter_, where you'll find:

	|-- API 			-> Rails App.
	|-- Docs.			-> References documents
	|-- Storriter		-> Node.js (Express.js) App.

Now you need to start the Rails server and Node.js server.

####Rails API
>`$ cd API` 

Run `$ bunlde install` to install all the gems, then `$ rake db:migrate` to set up the database.
* To try the app with try it with fake users you can populate the database running `$ bundle exec rake db:populate` it will run a Rake task (_lib/tasks/sample_data.rake_) that will populate the database..

Now you can start the Rails server `$ rails s`. 
>By default it'll run on port _3000_ (and Node.js on port _5000_)

####Node.js Server
>`$ cd Storitter` 

>Make sure you already have installed NPM on you machine. [NPM](http://npmjs.org/)

With Node.js you'll be able to test the API, as well as the realtime notifications on the users pages (/users)

First you need install all dependencies on your local directory (_Storitter_), run `$ npm install`. All the dependencies are specified on _package.json_

Run `$ ./bin/devserver` to start the Node.js server.

## Try it

Having everything ready and running, go to `http://localhost:3000/posts/new`, it'll redirect you to the _home_ page where you will have to login first, click on the _Login_ link and you'll be send to you Facebook account to give us the permission to use you're account on the Storitter App in order to be authenticated. 

It will post on your Timeline in Facebook "_Me has just joined Storitter_" and send a welcome email. Now you can try going to `http://localhost:3000/posts/new` again.

Open a new tab and go to `http://localhost:5000/users` there you'll see all the users on the app, you can even _follow_ any of them. 

##### Interaction in real time

Ok so, having some _followings_ you can enter in his/her profile and see in real time if any of his/her followings create a new post. You can simulate it doing this:
* Open two tabs on your browser, in the first tab go to `http://localhost:3000/posts/new` and in the second tab got to `http://localhost:5000/users/:id` (reaplce _:id_) for any your followings id's)
* Create a new post
* And finally look what happend in your following wall :)