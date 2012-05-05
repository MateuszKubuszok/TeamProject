class CreateTeamInvitations < ActiveRecord::Migration
  def change
    create_table :team_invitations do |t|
      t.integer :id
      t.integer :project_id
      t.integer :user_id
    end
  end
end
