class CreateProjectFacts < ActiveRecord::Migration
  def change
    create_table :project_facts do |t|
      t.integer :id
      t.integer :date_id
      t.integer :project_id
      t.integer :visits
    end
  end
end