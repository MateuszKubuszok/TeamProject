class CreateTicketFacts < ActiveRecord::Migration
  def change
    create_table :ticket_facts do |t|
      t.integer :id
      t.integer :date_id
      t.integer :ticket_id
      t.integer :user_id
      t.integer :status_id
      t.integer :priority_id
      t.date    :deadline
    end
  end
end