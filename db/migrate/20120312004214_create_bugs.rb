class CreateBugs < ActiveRecord::Migration
  def change
    create_table :bugs do |t|
      t.integer :id
      t.integer :project_id
      t.integer :status_id
      t.integer :type_id
      t.integer :priority_id
      t.string :short_description
      t.text :description
      t.text :commentary

      t.timestamps
    end
  end
end
