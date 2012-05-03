class CreateUserConfigurations < ActiveRecord::Migration
  def change
    create_table :user_configurations do |t|
      t.integer :id
      t.integer :user_id
      t.integer :language
      t.integer :contact_privacy_level
      t.integer :personal_data_privacy_level
      t.integer :projects_privacy_level
      t.integer :privileges_privacy_level
      t.integer :blog_privacy_level
      t.boolean :widescreen
    end
  end
end
