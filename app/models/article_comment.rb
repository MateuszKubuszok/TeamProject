class ArticleComment < ActiveRecord::Base
end
# == Schema Information
#
# Table name: article_comments
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  article_id :integer(4)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

