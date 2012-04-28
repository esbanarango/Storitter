class Profile < ActiveRecord::Base

	#Associations
	belongs_to :user
  	belongs_to :employee

	attr_accessible :profile_picture 
	has_attached_file :profile_picture, :styles => { :small => "100x100>", :medium => "300x300>", :large => "400x400>" }

end
