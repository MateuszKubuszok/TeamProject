class MilestonesController < ApplicationController
  admin_requirements  :manage_projects
  team_requirements   :manage_milestones
  before_filter       :require_project_admin, only: [ :new, :create, :edit, :update, :destroy ]
  before_filter       :require_public,        only: [ :index, :show ]

  before_filter       :load_project
  before_filter       :load_milestone,        only: [ :show, :edit, :update, :destroy ]

  # GET /projects/1/milestones
  # GET /projects/1/milestones.json
  def index
    @milestones = @project.milestones.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @milestones }
    end
  end

  # GET /projects/1/milestones/1
  # GET /projects/1/milestones/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @milestone }
    end
  end

  # GET /projects/1/milestones/new
  # GET /projects/1/milestones/new.json
  def new
    @milestone = Milestone.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @milestone }
    end
  end

  # GET /projects/1/milestones/1/edit
  def edit
  end

  # POST /projects/1/milestones
  # POST /projects/1/milestones.json
  def create
    @milestone = Milestone.new(params[:milestone])
    @milestone.project_id = @project.id

    respond_to do |format|
      if @milestone.save
        format.html { redirect_to project_milestone_path(@project.url_name, @milestone.id), notice: 'Milestone was successfully created.' }
        format.json { render json: @milestone, status: :created, location: project_milestone_path(@project.url_name, @milestone.id) }
      else
        format.html { render action: "new" }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1/milestones/1
  # PUT /projects/1/milestones/1.json
  def update
    respond_to do |format|
      if @milestone.update_attributes(params[:milestone])
        format.html { redirect_to project_milestone_path(@project.url_name, @milestone.id), notice: 'Milestone was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @milestone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1/milestones/1
  # DELETE /projects/1/milestones/1.json
  def destroy
    @milestone.destroy

    respond_to do |format|
      format.html { redirect_to project_milestones_path(@project.url_name) }
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

  # pobiera milestone
  def load_milestone
    @milestone = Milestone.find_by_id_and_project_id params[:id], @project.id
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to(project_path(@project.url_name), :notice => "#{$!}") }
      format.json { head :not_found }
    end
  end
end
