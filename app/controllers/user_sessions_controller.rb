class UserSessionsController < ApplicationController
  before_filter :require_user,    only: [ :destroy ]
  before_filter :require_no_user, only: [ :new, :create ]

  # Tworzy formularz logowania.
  #
  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_session }
    end
  end

  # Tworzy sesję użytkownika na podstawie danych z formularza i przekierwuje do lokacji, w której zarządano logowania.
  #
  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])

    puts YAML.dump(params[:user_session])

    respond_to do |format|
      if @user_session.save
        format.html { redirect_to(redirect_back_or_default(:users), :notice => 'Login Successful!') }
        format.xml  { render :xml => @user_session, :status => :created, :location => @user_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Wylogowuje użytkownika i przekierowuje go na stronę główną.
  #
  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find
    @user_session.destroy

    respond_to do |format|
      format.html { redirect_to(homepage_path, :notice => 'Goodbye!') }
      format.xml  { head :ok }
    end
  end
end