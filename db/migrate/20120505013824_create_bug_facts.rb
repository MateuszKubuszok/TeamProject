class CreateBugFacts < ActiveRecord::Migration
  def change
    create_table :bug_facts do |t|
      t.integer :id
      t.integer :date_id
      t.integer :bug_id
      t.integer :type_id
      t.integer :status_id
    end
  end
end