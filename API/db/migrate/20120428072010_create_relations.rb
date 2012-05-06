class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
    	  t.integer :follower_id
      	t.integer :following_id
        t.boolean :forbid, :default => false

      	t.timestamps
    end

    add_index :relations, :follower_id
    add_index :relations, :following_id
    add_index :relations, [:follower_id, :following_id], unique: true
    
  end
end
