class User < Profile
	attr_accessible :username, :email

	#Associations
	has_many :posts, dependent: :destroy
	has_many :relations, foreign_key: "follower_id", dependent: :destroy
	has_many :following_users, through: :relations, source: :following

	has_many :reverse_relations, foreign_key: "following_id",
                                   class_name:  "Relation",
                                   dependent:   :destroy
  	has_many :followers, through: :reverse_relations, source: :follower
  	

	def following?(other_user)
		relations.find_by_following_id(other_user.id)
	end

	def follow!(other_user)
		relations.create!(following_id: other_user.id)
	end

	def unfollow!(other_user)
		relations.find_by_following_id(other_user.id).destroy
	end

end
