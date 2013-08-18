class CreateBugFacts < ActiveRecord::Migration
  def connection
    BugFact.connection
  end

  def change
    create_table :bug_facts do |t|
      t.integer :id
      t.integer :date_id
      t.integer :bug_id
      t.string  :date_bug
    end
  end
end