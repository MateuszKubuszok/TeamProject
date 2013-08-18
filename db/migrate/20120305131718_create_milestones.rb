class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.integer :id
      t.integer :project_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
