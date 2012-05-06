class Post < ActiveRecord::Base
	attr_accessible :message

	belongs_to :user

	validates :user_id, presence: true
	validates :message, presence: true, length: { maximum: 149 }

	acts_as_api

	api_accessible :user_with_posts do |t|
		t.add :user_id
	    t.add :message
	    t.add :updated_at
	    t.add :visible
	end

	default_scope order: 'posts.created_at DESC'

	scope :from_users_following_by, lambda { |id| following_by(id) }

	 private

	# Returns an SQL condition for users followed by the given user.
	# We include the user's own id as well.
	def self.following_by(id)
		following_user_ids = %(SELECT following_id FROM relations
	                            WHERE follower_id = :user_id)
	      where("user_id IN (#{following_user_ids}) OR user_id = :user_id",
	            { user_id: id })
	 end


end
