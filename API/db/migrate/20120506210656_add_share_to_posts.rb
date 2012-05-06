class AddShareToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :share, :boolean, :default => false

  end
end
