class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :forum_thread_id
      t.integer :user_id
      t.integer :edited_by
      t.string  :title
      t.text    :content

      t.timestamps
    end
  end
end
