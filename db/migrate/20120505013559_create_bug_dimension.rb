class CreateBugDimension < ActiveRecord::Migration
  def change
    create_table :bug_dimension do |t|
      t.integer :id
      t.integer :date_id
      t.integer :project_id
      t.integer :bug_id
      t.string  :short_description
      t.text    :description
      t.text    :commentary
    end
  end
end