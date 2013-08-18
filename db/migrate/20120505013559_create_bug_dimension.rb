class CreateBugDimension < ActiveRecord::Migration
  def connection
    BugDimension.connection
  end

  def change
    create_table :bug_dimension do |t|
      t.integer :id
      t.integer :date_id
      t.integer :bug_id
      t.integer :project_id
      t.string  :project_name
      t.text    :project_description
      t.integer :type_id
      t.string  :type_name
      t.string  :short_description
      t.text    :description
      t.text    :commentary
      t.boolean :resolved
      t.string  :date_bug
    end
  end
end