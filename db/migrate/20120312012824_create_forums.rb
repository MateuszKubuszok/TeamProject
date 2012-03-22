class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.integer :id
      t.integer :forum_id
      t.string :name
      t.string :description
      t.integer :project_id
      t.boolean :private

      t.timestamps
    end
  end
end
