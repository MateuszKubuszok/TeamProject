class CreateProjectFacts < ActiveRecord::Migration
  def connection
    ProjectFact.connection
  end

  def change
    create_table :project_facts do |t|
      t.integer :id
      t.integer :date_id
      t.integer :project_id
      t.integer :visits
      t.string  :date_project
    end
  end
end