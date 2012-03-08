class ProjectsController < ApplicationController
  admin_requirements                    any:  [ :manage_projects ]
  team_requirements                     any:  [ :manage_project , :manage_team ]
  before_filter :require_user,          only: [ :my, :new, :create ]
  before_filter :require_public,        only: [ :show ]
  before_filter :require_project_admin, only: [ :edit, :update, :destroy ]

  before_filter :load_project,          only: [ :show, :edit, :update, :destroy, :edit_member, :update_member, :remove_member ]
  before_filter :load_user,             only: [ :edit_member, :update_member, :remove_member ]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(private: false).order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/my
  # GET /projects/my.json
  def my
    @projects = current_user.projects.order(:name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save_for current_user.id
        format.html { redirect_to project_path(@project.url_name), notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: project_path(@project.url_name) }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to project_path(@project.url_name), notice: 'Project was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :ok }
    end
  end

  # GET /projects/1/user/edit_member
  def edit_member
  end

  # PUT /projects/1/user
  # PUT /projects/1/user.json
  def update_member
    respond_to do |format|
      if @upr.update_attributes(params[:user_project_relationship])
        format.html { redirect_to project_path(@project.url_name), notice: 'Project\'s member was successfully updated.' }
        format.json { head :ok }
      else
        puts YAML.dump(params)
        format.html { render action: "edit_member" }
        format.json { render json: @upr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1/user
  # DELETE /projects/1/user.json
  def remove_member
    @upr.destroy

    respond_to do |format|
      format.html { redirect_to project_path(@project.url_name) }
      format.json { head :ok }
    end
  end

  private

  # Pobiera projekty.
  def load_project
    @project = current_project
  end

  # Pobiera użytkownika.
  def load_user
    begin
      @user = User.find_by_url params[:user_id]
      @upr = UserProjectRelationship.find_by_project_id_and_user_id @project.id, @user.id
      if @upr.blank?
        respond_to do |format|
          format.html { redirect_to(project_path(@project.url_name), :notice => "You cannot remove user from project if he isn't part of it!'") }
          format.json { head :unprocessable_entity }
        end
      end
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to(project_path(@project.url_name), :notice => "#{$!}") }
        format.json { head :not_found }
      end
    end
  end
end
