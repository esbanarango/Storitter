class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.string :username, :null => false, :limit => 40
    	t.string :first_name, :limit => 30
    	t.string :last_name, :limit => 30
    	t.string :email, :null => false, :unique => true, :limit => 255
      t.timestamps
    end
  end
end
