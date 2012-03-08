class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :id
      t.string :url_name
      t.string :name
      t.string :short_description
      t.string :description
      t.boolean :private

      t.timestamps
    end
  end
end