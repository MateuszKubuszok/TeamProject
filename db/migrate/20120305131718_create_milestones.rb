class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :id
      t.string :name
      t.string :description
      t.integer :project_id

      t.timestamps
    end
  end
end