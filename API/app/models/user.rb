class User < ActiveRecord::Base

	#Associations
	has_one :profile

end
