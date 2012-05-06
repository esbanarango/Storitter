class Post < ActiveRecord::Base
	attr_accessible :message

	belongs_to :user

	validates :user_id, presence: true
	validates :message, presence: true, length: { maximum: 149 }

	acts_as_api

	api_accessible :user_with_posts do |t|
	    t.add :message
	    t.add :updated_at
	    t.add :visible
	end


	default_scope order: 'posts.created_at DESC'

end
