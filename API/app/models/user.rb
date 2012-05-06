class User < Profile
	attr_accessible :username, :email, :first_name, :last_name, :fb_uid, :fb_access_token

	after_create :confirmation_and_welcome_notification

	#Associations
	has_many :posts, dependent: :destroy
	has_many :relations, foreign_key: "follower_id", dependent: :destroy
	has_many :following_users, through: :relations, source: :following

	has_many :reverse_relations, foreign_key: "following_id",
                                   class_name:  "Relation",
                                   dependent:   :destroy
  	has_many :followers, through: :reverse_relations, source: :follower
  	
  	has_one :session

  	acts_as_api

  	# Template for basic user info
  	api_accessible :return_public do |template|
  		template.add :id
		template.add :username
  		template.add :first_name
	    template.add :last_name
	    template.add :email
	    template.add :followers_count
		template.add :followings_count
		template.add :posts_count
	end

	api_accessible :return_info_follow do |template|
		template.add :id
		template.add :username
		template.add :followers_count
		template.add :followings_count
		template.add :posts_count
		template.add :profile_picture_small
	end

	# Complete user info with post
	api_accessible :user_with_posts do |template|
		template.add :id
		template.add :username
  		template.add :first_name
	    template.add :last_name
	    template.add :email
	    template.add :followers_count
		template.add :followings_count
		template.add :posts_count
		template.add :posts
		template.add :followings_posts
	end


	# Public methods for ac_as_api
	def followers_count
		self.followers.count
	end
	def followings_count
		self.following_users.count
	end
	def followings_posts
		Post.from_users_following_by(self)
	end
	def posts_count
		self.posts.count
	end

	def profile_picture_small
	    avatars = {}
	    avatars[:small]   = profile_picture.url(:small)
	    avatars
	 end




	def following?(other_user)
		relations.find_by_following_id(other_user.id)
	end

	def follow!(other_user)
		relations.create!(following_id: other_user.id)
	end

	def unfollow!(other_user)
		relations.find_by_following_id(other_user.id).destroy
	end

	def confirmation_and_welcome_notification
		UserMailer.registration_confirmation(self).deliver		
	end

end
