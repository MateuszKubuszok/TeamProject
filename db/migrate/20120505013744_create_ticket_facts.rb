class CreateTicketFacts < ActiveRecord::Migration
  def connection
    TicketFact.connection
  end

  def change
    create_table :ticket_facts do |t|
      t.integer :id
      t.integer :date_id
      t.integer :ticket_id
      t.integer :user_id
      t.integer :till_deadline
      t.string  :date_pmt
      t.string  :date_user
    end
  end
end