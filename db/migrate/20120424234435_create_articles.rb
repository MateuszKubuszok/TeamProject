class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :id
      t.integer :user_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
