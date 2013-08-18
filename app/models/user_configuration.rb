class UserConfiguration < ActiveRecord::Base
  belongs_to :user

  validate  :user_id,   presence:   true,
                        uniqueness: true
  validate  :user,      presence:   true
end
# == Schema Information
#
# Table name: user_configurations
#
#  id                          :integer(4)      not null, primary key
#  user_id                     :integer(4)
#  language                    :integer(4)
#  contact_privacy_level       :integer(4)
#  personal_data_privacy_level :integer(4)
#  projects_privacy_level      :integer(4)
#  privileges_privacy_level    :integer(4)
#  blog_privacy_level          :integer(4)
#  widescreen                  :boolean(1)
#

