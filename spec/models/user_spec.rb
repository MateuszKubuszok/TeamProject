require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  url_name            :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  email               :string(255)
#  name                :string(255)
#  about_me            :string(255)
#  privileges          :integer(4)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  last_login_at       :datetime
#  last_request_at     :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

