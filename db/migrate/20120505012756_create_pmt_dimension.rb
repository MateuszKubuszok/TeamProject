class CreatePmtDimension < ActiveRecord::Migration
  def connection
    PmtDimension.connection
  end

  def change
    create_table :pmt_dimension do |t|
      t.integer :id
      t.integer :date_id
      t.integer :project
      t.integer :milestone
      t.integer :ticket
      t.string  :project_name
      t.string  :milestone_name
      t.string  :ticket_name
      t.text    :ticket_description
      t.integer :ticket_priority_id
      t.string  :ticket_priority
      t.boolean :private
      t.boolean :completed
      t.date    :ticket_deadline
      t.boolean :deadline
      t.string  :date_pmt
    end
  end
end