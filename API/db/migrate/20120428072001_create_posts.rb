class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|

    	t.integer :profile_id, :null => false
    	t.text :message, :null => false, :limit => 149
    	t.boolean :visible, :default => true

      t.timestamps
    end
  end
end
