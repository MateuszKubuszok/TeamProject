class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :id
      t.string :login
      t.string :url_name
      t.string :crypted_password
      t.string :password_salt
      t.string :email
      t.string :name
      t.string :about_me
      t.integer :privileges
      t.string :persistence_token
      t.string :single_access_token
      t.string :perishable_token
      t.datetime :last_login_at
      t.datetime :last_request_at

      t.timestamps
    end
  end
end
