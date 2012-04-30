class CreateProfiles < ActiveRecord::Migration
	
  def change
    create_table :profiles do |t|
    	t.string :username, :null => false, :limit => 40
    	t.string :first_name, :limit => 30
    	t.string :last_name, :limit => 30
    	t.string :email, :null => false, :unique => true, :limit => 255

    	# Single Table Inheritance Attributes
    	t.string :type, :null => false

    	# User attributes
    	t.string :fb_uid, :unique => true
    	t.string :fb_access_token
    	t.boolean :private, :default => false
    	t.boolean :facebook_autoshare, :default => true
    	# Employee attributes
    	t.string :function, :limit => 40
    	t.string :department, :limit => 40
    	t.string :password, :limit => 20

      t.timestamps
    end
  end
end
