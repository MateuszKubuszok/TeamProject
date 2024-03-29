class UsersController < ApplicationController
  admin_requirements                    any:  [ :manage_privileges, :manage_users ]
  before_filter       :require_access,  only: [ :edit, :update, :destroy ]
  before_filter       :require_user,    only: [ :invite ]
  before_filter       :require_no_user, only: [ :new, :create ]

  before_filter       :load_user,       only: [ :show, :edit, :update, :destroy, :invite ]
  before_filter       :secure_received

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_path(@user.url_name), notice: 'User was successfully registered.' }
        format.json { render json: @user, status: :created, location: user_path(@user.url_name) }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to user_path(@user.url_name), notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  # GET /users/1/invite
  # GET /users/1/invite.json
  def invite
    @projects = current_user.projects-@user.projects-@user.possible_projects

    respond_to do |format|
      format.html # invite.html.erb
      format.json { render json: @projects }
    end
  end

  private

  # Pobiera użytkownika.
  def load_user
    @user = User.find_by_url params[:id]
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(homepage_path, :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end

  # Określa, czy użytkownik sesji jest właścicielem zasobów.
  #
  # @return [boolean] true, jeśli użytkowink jest właścicielem
  def owner?
    user = current_user
    user && (params[:id].to_i.zero? ? user.url_name.eql?(params[:id]) : user.id.to_s.eql?(params[:id]))
  end

  # Usuwa z params[:user] uprawnienia administratora, jeśli wysyłający je użytkownik nie jest administratorem.
  def secure_received
    unless meet_requirements? :manage_privileges
      [
          :crypted_password,
          :password_salt,
          :premium_until,
          :privileges,
          :persistence_token,
          :single_access_token,
          :perishable_token,
          :last_login_at,
          :last_request_at
      ].each { |attribute| params[:user].delete attribute if params[:user][attribute] }
      User.symbols(:privilege_types).each { |privilege| params[:user][privilege] = "0" if params[:user][privilege] }
    end if params[:user]
  end
end
