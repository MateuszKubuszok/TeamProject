class CreateUserProjectRelationships < ActiveRecord::Migration
  def change
    create_table :user_project_relationships do |t|
      t.integer :id
      t.integer :user_id
      t.integer :project_id
      t.integer :privileges

      t.timestamps
    end
  end
end
