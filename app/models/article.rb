class Article < ActiveRecord::Base
end
# == Schema Information
#
# Table name: articles
#
#  id                :integer(4)      not null, primary key
#  user_id           :integer(4)
#  title             :string(255)
#  content           :text
#  comments_level_id :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

