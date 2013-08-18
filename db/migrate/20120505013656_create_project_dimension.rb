class CreateProjectDimension < ActiveRecord::Migration
  def connection
    ProjectDimension.connection
  end

  def change
    create_table :project_dimension do |t|
      t.integer :id
      t.integer :date_id
      t.integer :project_id
      t.string  :name
      t.string  :url_name
      t.string  :short_description
      t.text    :description
      t.string  :date_project
    end
  end
end