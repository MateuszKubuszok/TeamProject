class TeamInvitation < ActiveRecord::Base
  belongs_to  :project
  belongs_to  :user

  # Akceptuje zaproszenie do zespołu.
  #
  # @return [boolean] true, jeśli zapis się powiódł
  def accept
    begin
      accept!
      true
    rescue ActiveRecord::RecordInvalid
      false
    end
  end

  # Akceptuje zaproszenie do zespołu.
  #
  # @raise [ActiveRecord::RecordInvalid] wyrzuca wyjątek jeśli zapis się nie powiódł
  def accept!
    self.transaction do
      upr = UserProjectRelationship.new({
        'user_id'     => self[:user_id],
        'project_id'  => self[:project_id]
      })
      upr.save!
      self.destroy
    end
  end
end
# == Schema Information
#
# Table name: team_invitations
#
#  id         :integer(4)      not null, primary key
#  project_id :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

