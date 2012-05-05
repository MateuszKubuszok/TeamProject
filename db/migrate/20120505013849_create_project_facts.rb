class CreateProjectFacts < ActiveRecord::Migration
  def connection
    ActiveRecord::Base.establish_connection("#{Rails.env}_warehouse").connection
  end

  def change
    create_table :project_facts do |t|
      t.integer :id
      t.integer :date_id
      t.integer :project_id
      t.integer :visits
    end
  end
end