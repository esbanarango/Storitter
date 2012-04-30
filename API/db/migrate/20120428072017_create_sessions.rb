class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
    	t.string :access_token, :null => false
    	t.integer :profile_id, :null => false
    	
      t.timestamps
    end
  end
end
