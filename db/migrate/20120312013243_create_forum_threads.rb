class CreateForumThreads < ActiveRecord::Migration
  def change
    create_table :forum_threads do |t|
      t.integer :id
      t.integer :forum_id
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :edited_by

      t.timestamps
    end
  end
end
