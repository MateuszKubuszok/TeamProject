class ProjectElementController < ApplicationController
  helper_method :allowed_to_see?,
                :current_project,
                :meet_team_requirements?

  protected

  # Zwraca projekt dla danego kontrolera.
  #
  # @return [Project] bieżacy projekt
  def current_project
    defined?(@project) ? @project : (@project = Project.find_by_url params[:project_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(homepage_path, notice: "#{$!}") }
      format.json { head :not_found }
    end
  end

  # Specyfikuje uprawnienia członka projektu, jeśli jakieś konkretne są wymagane.
  #
  # Przyjmuje takie argumenty jak funkcja team_requirements?
  #
  # (see #team_requirements?)
  #
  # @param [array] tablica/hash zawierający uprawnienia
  def self.team_requirements privileges
    @@team_requirements = privileges
  end

  # Określa, czy użytkownik ma dostęp do zasobu - zasoby prywatne mogą oglądać tylko właściciele i adminstratorzy.
  #
  # @param  [Project] project sprawdzany projekt
  # @return [boolean]         true, jeśli użytkownik ma dostęp
  def allowed_to_see? project=current_project
    !project.blank? && (!project.private? || (current_user && current_user.admin?) || project.users.include?(current_user))
  end

  # Określa, czy użytkownik ma wymagane uprawnienia w danym projekcie.
  #
  # Drugi opcjonalny argument określa projekt - domyślnie jest to projekt bieżący jeśli taki zdefiniowano.
  #
  # Dopuszczalne formaty:
  # 1. 1 wymagane uprawnienie:
  #    meet_team_requirements? :uprawnienie
  # 2. kilka wymaganych uprawnień jednocześnie:
  #    meet_team_requirements? [ :uprawnenie1, :uprawnienie2 ] #
  # 3. wymagane kilka uprawnień jednocześnie (:all) )i/lub co najmniej jedno z kilku (:any)):
  #    meet_team_requirements? [ :all => [ :uprawnienie1 ], :any => [ :uprawnienie2 ] ]
  #
  # (see #member_requirements)
  #
  # @param [array]    requirements  tablica/hash zawierający uprawnienia
  # @param [Project]  project       projekt dla którego sprawdzamy uprawnienia
  def meet_team_requirements? requirements, project=current_project
    user = current_user
    if user.nil?
      false
    elsif user.admin?
      true
    else
      return false if project.blank? or not (project.users).include?(user)
      privileges = UserProjectRelationship.find_by_user_id_and_project_id user.id, project.id
      if requirements.respond_to?(:has_key?) && (requirements.has_key?(:all) || requirements.has_key?(:any))
        access = true
        access = (access && (privileges.allowed_to_all? requirements[:all])) if requirements.has_key?(:all)
        (access && (privileges.allowed_to_any? requirements[:any])) if requirements.has_key?(:any)
      else
        privileges.allowed_to_all? requirements
      end
    end
  end

  # Określa, czy użytkownik sesji jest właścicielem zasobów.
  #
  # @return [boolean] true, jeśli użytkowink jest właścicielem
  def owner?
    (current_project.users).include?(current_user)
  end

  # Filtr before_filter. Dopuszcza do zasobów wyłącznie adminów, oraz członków projektu z odpowiednimi uprawnieniami.
  def require_project_admin
    unless meet_team_requirements?(@@team_requirements)
      store_location
      respond_to do |format|
        format.html { redirect_to(current_user ? homepage_path : login_path, :notice => "You must be a project administrator to access this page!") }
        format.json { head :unauthorized }
      end
    end
  end

  # Filtr before_filter. Dopuszcza do prywatnych zasobów tylko administratorów i właścicieli.
  def require_public
    unless allowed_to_see?
      store_location
      respond_to do |format|
        format.html { redirect_to(current_user ? homepage_path : login_path, :notice => "You tried to access private project!") }
        format.json { head :unauthorized }
      end
    end
  end
end