class UserProjectRelationship < ActiveRecord::Base
  extend SymbolInteger
  extend MultipleBoolField

  define_symbols :privilege_types, [
    :manage_project,
    :manage_team,
    :manage_milestones,
    :manage_tickets,
    :manage_forums
  ]

  belongs_to :user
  belongs_to :project

  bool_accessors :privilege_types, :privileges

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
end
# == Schema Information
#
# Table name: user_project_relationships
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  project_id :integer(4)
#  privileges :integer(4)
#

