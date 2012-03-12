class Project < ActiveRecord::Base
  acts_as_taggable

  has_many  :team_invitations,            dependent:      :destroy
  has_many  :possible_users,              source:         :user,
                                          through:        :team_invitations
  has_many  :user_project_relationships,  dependent:      :destroy
  has_many  :users,                       through:        :user_project_relationships,
                                          dependent:      :destroy
  has_many  :milestones,                  dependent:      :destroy

  validates :name,                        presence:       true
  validates :url_name,                    presence:       true,
                                          uniqueness:     true,
                                          id_replacement: true,
                                          format:         {
                                                            with:     /\A[a-z0-9\._-]+\Z/i,
                                                            message:  "should use only letters, numbers (but not just numbers), and .-_ please"
                                                          }

  # Zwraca projekt na podstawie ID podanego w adresie URL.
  #
  # @param  [string] url_id id podane w adresie URL.
  # @return [User]          użytkownik
  def self.find_by_url url_id
    url_id.to_i.zero? ? Project.find_by_url_name(url_id) : Project.find(url_id)
  end

  # Zwraca uprawnienia w projekcie dla danego użytkownika.
  #
  # @param  [integer]                 id użytkownika
  # @return [UserProjectRelationship]
  def privileges_for user_id
    UserProjectRelationship.find_by_user_id_and_project_id user_id, self[:id]
  end

  # Zapisuje projekt i tworzy dowiązanie dla użytkownika tworzącego projekt.
  #
  # @param  [integer] user_id id użytkownika
  # @return [boolean]
  def save_for user_id
    save_for! user_id
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  # Zapisuje projekt i tworzy dowiązanie dla użytkownika tworzącego projekt.
  #
  # @raise [ActiveRecord::InvalidRecord] zwraca wyjątek jeśli nie udało się zapisać projektu i dowiązania
  #
  # @param  [integer] user_id id użytkownika
  # @return [boolean]
  def save_for! user_id
    self.transaction do
      save!
      upr = UserProjectRelationship.new({
        'user_id'    => user_id,
        'project_id' => self[:id],
        'privileges' => (2**(UserProjectRelationship.symbols_quantity :privilege_types)-1).to_s
      })
      upr.save!
    end
  end
end
# == Schema Information
#
# Table name: projects
#
#  id                :integer(4)      not null, primary key
#  url_name          :string(255)
#  name              :string(255)
#  short_description :string(255)
#  description       :text
#  private           :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#

