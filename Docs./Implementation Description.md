
## Technologies used.

For this project I used basically two major technologies **Ruby on Rails** (Version 3.2.1) with these Gems:

* Paperclip (file attachments for model, ie: profile pictures)
* acts\_as\_api (predefined response templates for model)
* cancan (authorization, restrict access)
* kaminari (pagination)
* koala (access to facebook graph)
* faker (easily generate fake data: names, addresses, phone numbers, etc.)
* rspec-rails and  factory_girl_rails (testing)

and **Node.js** (Version 0.6.17) along with express.js and Socket.io.

## Issues solved.

##### Using acts_as_api with Paperclip

Using _acts as api_ I faced a problem trying to include an :attachment, in this case the _profile picture_, in one of the templates on User Active Record. Googling I found that someone already had the same problem and that issue ([Issue #47](https://github.com/fabrik42/acts_as_api/issues/47#issuecomment-5545693)) was already _closed_ on _acts as api_ GitHub repository. The solution for this issue was presented by _fabrik42_ and all that I have to do was just create a helper methond in the User model that constructs a Hash:
```ruby
def profile_picture_small
    avatars = {}
    avatars[:small]   = profile_picture.url(:small)
    avatars
 end
```
and then add it to th template `template.add :profile_picture_small`


##### Cross Domain requests

As mentioned before, the Rails project is just the API for the App, so it has to responde to multiple clients. The client that I made here was the Node.js application, so Node.js has to comunicate with Rails. The problem here was that when you make a request from Node.js to a Rails app, it won't create a session, so, supose you want to retrieve all the Followers from the _current user_ (the user logged from Rails app), the _current user_ session does not exist if you would make that request directly from node.js. This problem might have multiple solutions. The solution which I used was through Ajax, I'll explain it below:

To keep having the current user session available from Node.js we must use a Cross Domain requests from Node.js to Rails.
> It is a cross domain request because Rails is running on port 3000 and Node on port 5000
So Jquery make it so easy for us! :)

Client side code:
```javascript
jQuery.getJSON("http://localhost:3000/myfollowers.js?callback=?",function(data) {
	// Handle response here
	console.info("Rails returned: ",data);
});
```

Server side code:
```ruby
def my_followers
    current_user = User.find(session[:user_id])
    followers = current_user.followers()
    respond_with do |format|
      format.json { render_for_api :return_public, :json => followers, :root => :users }
      #If we want to respon to a JSONP
      j = ActiveSupport::JSON
      respondeToJsonp = params[:callback]+'('+j.encode(followers)+')'
      format.js   { render :json => respondeToJsonp }
    end
    
  end
```

