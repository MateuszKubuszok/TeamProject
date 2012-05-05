class CreatePmtDimension < ActiveRecord::Migration
  def change
    create_table :bug_dimension do |t|
      t.integer :id
      t.integer :date_id
      t.integer :project_id
      t.integer :milestone_id
      t.integer :ticket_id
      t.string  :project_name
      t.string  :milestone_name
      t.string  :ticket_name
      t.text    :ticket_description
      t.string  :private
    end
  end
end