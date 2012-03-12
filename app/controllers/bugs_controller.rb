class BugsController < ApplicationController
  admin_requirements :manage_projects
  before_filter :require_access, only: [ :edit, :update, :destroy ]
  before_filter :require_public, only: [ :index, :show ]

  before_filter :load_project
  before_filter :load_bug,       only: [ :show, :edit, :update, :destroy ]

  # GET /projects/1/bugs
  # GET /projects/1/bugs.json
  def index
    @bugs = @project.bugs.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bugs }
    end
  end

  # GET /projects/1/bugs/1
  # GET /projects/1/bugs/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bug }
    end
  end

  # GET /projects/1/bugs/new
  # GET /projects/1/bugs/new.json
  def new
    @bug = Bug.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bug }
    end
  end

  # GET /projects/1/bugs/1/edit
  def edit
  end

  # POST /bugs
  # POST /bugs.json
  def create
    @bug = Bug.new(params[:bug])
    @bug.project_id = @project.id

    respond_to do |format|
      if @bug.save
        format.html { redirect_to project_bug_path(@project.url_name, @bug.id), notice: 'Bug was successfully created.' }
        format.json { render json: @bug, status: :created, location: project_bug_path(@project.url_name, @bug.id) }
      else
        format.html { render action: "new" }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1/bugs/1
  # PUT /projects/1/bugs/1.json
  def update
    respond_to do |format|
      if @bug.update_attributes(params[:bug])
        format.html { redirect_to project_bug_path(@project.url_name, @bug.id), notice: 'Bug was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1/bugs/1
  # DELETE /projects/1/bugs/1.json
  def destroy
    @bug.destroy

    respond_to do |format|
      format.html { redirect_to project_bugs_path(@project.url_name) }
      format.json { head :ok }
    end
  end

  private

  # pobiera projekt
  def load_project
    @project = Project.find_by_url params[:project_id]
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(homepage_path, :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end

  # pobiera bug
  def load_bug
    @bug = Bug.find_by_id_and_project_id params[:id], @project.id
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(project_bugs_path(@project.url_name), :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end
end
