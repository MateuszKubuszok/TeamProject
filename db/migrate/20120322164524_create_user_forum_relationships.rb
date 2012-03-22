class CreateUserForumRelationships < ActiveRecord::Migration
  def change
    create_table :user_forum_relationships do |t|
      t.integer :id
      t.integer :user_id
      t.integer :forum_id
      t.integer :privileges
    end
  end
end
