class Employee < ActiveRecord::Base

	#Associations
	has_one :profile

end
