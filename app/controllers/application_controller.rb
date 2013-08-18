class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :tab,
                :current_user_session,
                :current_user,
                :meet_requirements?,
                :owner?,
                :widescreen_layout?,
                :widescreen_layout_switch,
                :bb_code

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

  # Określa, czy użytkownik sesji jest właścicielem zasobów.
  #
  # Uwaga! Funkcja powinno zostać nadpisana przez wykorzystujący ją kontroler.
  #
  # @return [boolean] true, jeśli użytkowink jest właścicielem
  def owner?
    true
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
    elsif requirements.blank?
      true
    elsif requirements.respond_to?(:has_key?) && (requirements.has_key?(:all) || requirements.has_key?(:any))
      access = true
      access = (access && (user.allowed_to_all? requirements[:all])) if requirements.has_key?(:all)
               (access && (user.allowed_to_any? requirements[:any])) if requirements.has_key?(:any)
    else
      user.allowed_to_all? requirements
    end
  end

  # Filtr before_filter. Dopuszcza do zasobów właściciela oraz administratorów z odpowiednimi uprawnieniami.
  def require_access
    unless meet_requirements?(@@requirements) || owner?
      respond_to do |format|
        format.html { redirect_to(current_user ? homepage_path : login_path, :notice => "You must be either an owner or an administrator to access this page!") }
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

  # Specyfikuje, która zakładka jest otwarta.
  #
  # @return [string] nazwa zakładki
  def tab
    return @tab if defined? @tab

    if %W(home projects users forums tags).include? controller_name
      @tab = controller_name
    elsif params.key? :project_id
      @tab = "projects"
    elsif params.key? :user_id
      @tab = "users"
    elsif params.key? :forum_id
      @tab = "forums"
    elsif params.key? :tag_id
      @tab = "tags"
    else
      @tab = nil
    end

    @tab
  end

  # Czy layout ma być rozciągnięty czy o stałej szerokości.
  def widescreen_layout?
    current_user ? current_user.widescreen_layout : (defined?(session[:widescreen_layout]) ? session[:widescreen_layout] : false)
  end

  # Zmienia ustawienia layoutu na przeciwne.
  def widescreen_layout_switch
    if current_user
      current_user.widescreen_layout ^= true
      current_user.save
    else session[:widescreen_layout]
      session[:widescreen_layout] = !widescreen_layout?
    end
  end

  # Zamienia BBCode z wejscia na HTML.
  #
  # @param [string] content BBCode
  # @return [string] HTML
  def bb_code content
    @bb_code_parser = RbbCode::Parser.new unless defined? @bb_code_parser
    @bb_code_parser.parse(ERB::Util.h content).html_safe
  end
end
