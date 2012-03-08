class Milestone < ActiveRecord::Base
  belongs_to  :project
  has_many    :tickets,     dependent:  :destroy

  validates   :name,        presence:   true
  validates   :project_id,  presence:   true
  validates   :project,     presence:   true
end
# == Schema Information
#
# Table name: milestones
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  project_id  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

