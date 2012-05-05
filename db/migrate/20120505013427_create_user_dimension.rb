class CreateUserDimension < ActiveRecord::Migration
  def connection
    ActiveRecord::Base.establish_connection("#{Rails.env}_warehouse").connection
  end

  def change
    create_table :user_dimension do |t|
      t.integer :id
      t.integer :date_id
      t.integer :user_id
      t.string  :login
      t.string  :name
      t.string  :surname
      t.text    :about_me
      t.string  :email
      t.string  :www
    end
  end
end