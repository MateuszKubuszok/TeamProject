class User < ActiveRecord::Base
  extend  SymbolInteger
  extend  MultipleBoolField

  define_symbols :privilege_types, [
    :manage_privileges,
    :manage_users,
    :manage_projects,
    :manage_forums
  ]
  bool_accessors :privilege_types, :privileges

  define_symbols :settings_types, [
    :widescreen_layout
  ]
  bool_accessors :settings_types, :settings

  has_many  :team_invitations,            dependent:      :destroy
  has_many  :possible_projects,           source:         :project,
                                          through:        :team_invitations
  has_many  :user_project_relationships,  dependent:      :destroy
  has_many  :projects,                    through:        :user_project_relationships
  has_many  :tickets

  validates :url_name,                    presence:       true,
                                          uniqueness:     true,
                                          id_replacement: true,
                                          format:         {
                                                            with:     /\A[a-z0-9\._-]+\Z/i,
                                                            message:  "should use only letters, numbers (but not just numbers), and .-_ please"
                                                          }

  # Łączy model User z modelem sesji UserSession.
  acts_as_authentic


  # Zwraca użytkownika na podstawie ID podanego w adresie URL.
  #
  # @param  [string] url_id id podane w adresie URL.
  # @return [User]          użytkownik
  def self.find_by_url url_id
    url_id.to_i.zero? ? User.find_by_url_name(url_id) : User.find(url_id)
  end

  # Proste wyszukiwanie użytkownika po nazwie lub e-mailu.
  #
  # @param  [string]  name  identyfikator po którym wyszukujemy
  # @return [array]         tablica użytkowników spełniających kryteria
  def self.search name
    where('name LIKE ? OR url_name LIKE ? OR email LIKE ?', "#{name}", "#{name}", "#{name}")
  end

  # Określa, czy użytkownik ma jakiekolwiek uprawnienia administratora.
  #
  # @return [boolean] true, jeśli użytkownik jest adminem
  def admin?
    self[:privileges] |= 0
    self[:privileges] > 0
  end

  # Określa, czy użytkownik ma jakiekolwiek uprawnienia administratora projektu.
  #
  # @param [integer] project_id id projektu
  # @return [boolean] true, jeśli użytkonik jest adminem
  def project_admin? project_id
    upr = privileges_for project_id
    upr.blank? ? false : !upr.privileges.to_i.zero?
  end

  # Określa, czy użytkownik ma wszystkie z wymienionych uprawnień.
  #
  # @param  [array]   privileges  tablica zawierająca uprawnienia
  # @return [boolean]             true, jeśli użytkownik posiada uprawnienia
  def allowed_to_all? privileges
    if privileges.respond_to? :each
      access = true
      privileges.each { |privilege_name| (access &&= self.send(privilege_name)) }
      access
    else
      self.send privileges
    end
  end

  # Określa, czy użytkownik ma którekolwiek z wymienionych uprawnień.
  #
  # @param  [array]   privileges  tablica zawierająca uprawnienia
  # @return [boolean]             true, jeśli użytkownik posiada uprawnienia
  def allowed_to_any? privileges
    if privileges.respond_to? :each
      access = false
      privileges.each { |privilege_name| (access ||= self.send(privilege_name)) }
      access
    else
      self.send privileges
    end
  end

  # Zwraca uprawnienia użytkownika dla danego projektu.
  #
  # @param  [integer]                 id projektu
  # @return [UserProjectRelationship]
  def privileges_for project_id
    UserProjectRelationship.find_by_user_id_and_project_id self[:id], project_id
  end
end
# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  email               :string(255)
#  url_name            :string(255)
#  name                :string(255)
#  surname             :string(255)
#  about_me            :text
#  www                 :string(255)
#  privileges          :integer(4)
#  settings            :integer(4)
#  language            :integer(4)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  last_login_at       :datetime
#  last_request_at     :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

