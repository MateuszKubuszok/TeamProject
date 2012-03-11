class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :allowed_to_see?,
                :current_user_session,
                :current_user,
                :meet_requirements?,
                :meet_team_requirements?,
                :owner?

  # Specyfikuje uprawnienia administratora, jeśli jakieś konkretne są wymagane.
  #
  # Przyjmuje takie argumenty jak funkcja meet_requirements?
  #
  # (see #meet_requirements?)
  #
  # @param [array] tablica/hash zawierający uprawnienia
  def self.admin_requirements privileges
    @@requirements = privileges
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

  private

  # Zwraca bieżącą sesję.
  #
  # @return [UserSession] bieżąca sesja
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  # Zwraca bieżącego użytkownika sesji (jeśli istnieje).
  #
  # @return [User] zalogowany użytkownik
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # Zwraca projekt dla bieżącej strony (jeśli jakiś jest dostępny).
  #
  # @return [Project] bieżący projekt
  def current_project
    return @current_project if defined?(@current_project)
    begin
      @current_project = Project.find_by_url('projects'.eql?(params[:controller]) ? params[:id] : params[:project_id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to(homepage_path, :notice => "#{$!}") }
        format.json { head :not_found }
      end
    end
  end

  # Określa, czy użytkownik sesji jest właścicielem zasobów.
  #
  # @return [boolean] true, jeśli użytkowink jest właścicielem
  def owner?
    user = current_user
    if (user_id = 'users'.eql?(params[:controller]) ? params[:id] : params[:user_id])
      user && (user_id.to_i.zero? ? user.url_name.eql?(user_id) : user.id.to_s.eql?(user_id))
    else
      project=current_project
      !project.blank? && (project.users).include?(user)
    end
  end

  # Określa, czy użytkownik ma dostęp do zasobu - zasoby prywatne mogą oglądać tylko właściciele i adminstratorzy.
  #
  # @param  [Project] project sprawdzany projekt
  # @return [boolean]         true, jeśli użytkownik ma dostęp
  def allowed_to_see? project=current_project
    !project.blank? && (!project.private? || (current_user && current_user.admin?) || project.users.include?(current_user))
  end

  # Określa, czy użytkownik ma wymagane uprawnienia administratorskie.
  #
  # Dopuszczalne formaty:
  # 1. 1 wymagane uprawnienie:
  #    meet_requirements? :uprawnienie
  # 2. kilka wymaganych uprawnień jednocześnie:
  #    meet_requirements? [ :uprawnenie1, :uprawnienie2 ] #
  # 3. wymagane kilka uprawnień jednocześnie (:all) )i/lub co najmniej jedno z kilku (:any)):
  #    meet_requirements? [ :all => [ :uprawnienie1 ], :any => [ :uprawnienie2 ] ]
  #
  # (see #admin_requirements)
  #
  # @param [array] requirements tablica/hash zawierający uprawnienia
  def meet_requirements? requirements
    user = current_user
    if user.nil? || !user.admin?
      false
    elsif requirements.nil?
      true
    elsif requirements.respond_to?(:has_key?) && (requirements.has_key?(:all) || requirements.has_key?(:any))
      access = true
      access = (access && (user.allowed_to_all? requirements[:all])) if requirements.has_key?(:all)
               (access && (user.allowed_to_any? requirements[:any])) if requirements.has_key?(:any)
    else
      user.allowed_to_all? requirements
    end
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
    puts "params:"+YAML.dump(params)
    puts "requirements:"+YAML.dump(requirements)
    user = current_user
    if user.nil?
      false
    elsif user.admin?
      true
    else
      puts "project:"+YAML.dump(project)
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

  # Filtr before_filter. Dopuszcza do zasobów właściciela oraz administratorów z odpowiednimi uprawnieniami.
  def require_access
    unless meet_requirements?(@@requirements) || owner?
      respond_to do |format|
        format.html { redirect_to(current_user ? homepage_path : login_path, :notice => "You must be either an owner or an administrator to access this page!")}
        format.json { head :unauthorized }
      end
    end
  end

  # Filtr before_filter. Dopuszcza do zasobów wyłącznie administratorów z odpowiednimi uprawnieniami.
  def require_admin
    unless meet_requirements?(@@requirements)
      store_location
      respond_to do |format|
        format.html { redirect_to(current_user ? homepage_path : login_path, :notice => "You must be an administrator to access this page!") }
        format.json { head :unauthorized }
      end
    end
  end

  # Filtr before_filter. Dopuszcza do zasobów wyłącznie niezalogowanych użytkowników.
  def require_no_user
    if current_user && !meet_requirements?(@@requirements)
      store_location
      respond_to do |format|
        format.html { redirect_to(homepage_path, :notice => "You must be logged out to access this page!") }
        format.json { head :unauthorized }
      end
    end
  end

  # Filtr before_filter. Dopuszcza do zasobów wyłącznie zalogowanych użytkowników.
  def require_user
    unless current_user
      store_location
      respond_to do |format|
        format.html { redirect_to(login_path, :notice => "You must be logged in to access this page!") }
        format.json { head :unauthorized }
      end
    end
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

  # Przechwutuje URL aby po zalogowaniu można było wrócić do poprzedniej lokacji.
  def store_location
    session[:return_to] = request.url
  end

  # Powraca do lokacji przechwyconej przed zalogowaniem.
  #
  # @param [string] default lokacja, do której powinien przekierować użytkownika jeśli żadna nie była zachowana wcześniej.
  def redirect_back_or_default(default)
    result = session[:return_to] || default
    session[:return_to] = nil
    result
  end
end
