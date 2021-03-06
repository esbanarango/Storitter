============================================

Using at least the following gems:

* rails (framework)
* paperclip (file attachments for model, ie: profile pictures)
* acts_as_api (predefined response templates for model)
* cancan (authorization, restrict access)
* kaminari (pagination)
* koala or/and fb_graph (share on facebook)

Imagine that you were at Twitter headquarters few years ago and it has been decided to use Ruby on Rails to develop the twitter API.
Four teams are working on the project: Front-end user (iOs/android client), Front-end admin (admin web-interface), IT (system and network), Back-end (you).

User interface and admin interface are totaly independant from the rails API, so no need views or assets.

There are no traps, if you have any question don't hesitate. Please use Git, I will send you a repository to push later.

Good luck ;)

============================================

Here are the minimum fields for each tables
^ = Required
˚ = Unique

Please use ActiveRecord for models, with a mysql, sqlite or postgresql database

--------------------------------------------

Profile
* ^username (40, longer name will be truncated, ie: "Totojskfj" will become "Toto.")
* first_name (30)
* last_name (30)
* ^˚email (255)
* profile_picture (3 sizes: small, medium, large)

--------------------------------------------

Employee < Profile
* ^function (40)
* ^department (40)
* ^password (8-20)

--------------------------------------------

User < Profile
* ^˚fb_uid
* ^fb_access_token
* private -> define if the user want to manually accept new followers, false by default
* facebook_autoshare -> decide if each action will be sent to facebook graph timeline, true by default
* banned (admin field)
* banned_by (admin field)
* banned_message (admin field)
* banned_at (admin field)
(maybe `banned` stuff can be somewhere else if you have a better idea, but not sure)

--------------------------------------------

Post
* ^user
* ^message (149)
* ^created_at (field automaticly generated by rails, but we need it on post response)
* visible (admin field, default to true)
* deleted_at (maybe duplicated with visible, depending on how you want to handle stuff, if the user remove his own post, then we completely remove it from database, if it is admin, we use this field, the user will still be able to retrieve his own post but we will display it in a different way)

--------------------------------------------

Relation
* ^follower < User
* ^following < User
* ^created_at
* forbid (default to false, if the following don't want the follower to follow it again, if this field is true, then the relation is virtualy not existing)
- ˚follower+following

--------------------------------------------

Session
* ^˚access_token
* ^profile

============================================

Following REST convention, here what the API should return in JSON format
If some calls may be improve or url are not the same it's ok, maybe it's better in an other way.

For facebook timeline, you are free to use koala or fb_graph or both, ask Enrique if you can he should have more informations than me.
You can create a new project on facebook developpers, and add me as developer at the end, so that I can see timeline messages.

--------------------------------------------

** Mobile app **

GET sessions?fb_access_token=XXX
RETURN {user, access_token}
The user will be fetch on facebook in order to get back his fb_uid, if the fb_uid is not in database, then we create a new user using facebook provided fields, don't forget the welcome mail ;)
If autopublish facebook: timeline message "Me has just joined projectname"

GET users
RETURN {users:[<last_registered_users>]
Comment: not private users

GET users/search?query=XXX&page=YY&limit=ZZ
RETURN {users:[]}

GET users/XX/followings
RETURN followings => {users:[{id, username, followers_count, followings_count, posts_count, profile_picture (small)}]}

GET users/XX/followers
RETURN followers => {users:[{id, username, followers_count, followings_count, posts_count, profile_picture (small)}]}

POST users/XX/follow
current_user added to followers of specified user
Mail to the following
If autopublish facebook: timeline message "Me is now following [facebook_profile] on projectname"

DELETE users/XX/followers
`forbid` will become true

DELETE users/XX/following
Remove the Relation (or disable it, but it doesn't mean the user will not be able to follow the guy again later)

PUT users/XX
RETURN {user}

DELETE users/XX
RETURN {success}

POST posts
additional attribute share=true can be sent to force the post publication on facebook timeline, if facebook_autoshare is true, then the post will be posted by default on facebook
If autopublish facebook: timeline message "Me has posted a [message] on projectname"

DELETE posts/XX
(delete your own post)

--------------------------------------------

** Admin app **

GET sessions?identifier=XXX&password=YYY
RETURN {user, access_token}
(identifier can be mail or email)

GET users/XX
Return detailled infos of a user and last 30 posts, 30 followers, 30 followings, followers_count, followings_count, posts_count

GET users/XX/posts?page=YY&limit=ZZ
GET users/XX/followings?page=YY&limit=ZZ
GET users/XX/followers?page=YY&limit=ZZ

PUT users/XX
Modify any user. A `posts_attributes:[{id:20, _destroy:true}, {id:30, _destroy:true}, {id:34, message:'CENSORED by moderation']` can also be passed in order to remove or modify existing posts of a user (check `accept_nested_attributes_for` in google). This method can also be used to add/remove followers/followings.

DELETE users/XX
Ban a user, a mail will be sent to XX explaining why, posts are not removed, they will simply be made invisible or not fetched or maybe another solution you find pertinent, look for the more optimized way to achieve this

PUT posts/XX

DELETE posts/YY
deleted_at = date

POST employees

============================================

BONUS :P

--------------------------------------------

Use TDD: implement unitary tests before you start coding

--------------------------------------------

Create a node.js (express.js + socket.io) script to handle real-time, you can create a quick page to implement your api client call (even if the page is dirty and work only with one predefined user), when a following of this user post a message, rails should call a node.js page, which will send the message to the current user without refreshing the page