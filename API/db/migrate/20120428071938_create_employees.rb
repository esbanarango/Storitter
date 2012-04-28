class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
    	t.string :function, :null => false, :limit => 40
    	t.string :department, :null => false, :limit => 40
    	t.string :password, :null => false, :limit => 20

      t.timestamps
    end
  end
end
