class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|

      t.timestamps
    end
  end
end
