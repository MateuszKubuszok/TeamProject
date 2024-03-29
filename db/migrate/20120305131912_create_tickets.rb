class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :id
      t.integer :milestone_id
      t.string :name
      t.text :description
      t.integer :status_id
      t.integer :priority_id
      t.integer :user_id
      t.date :deadline

      t.timestamps
    end
  end
end
