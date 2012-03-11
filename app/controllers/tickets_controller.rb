class TicketsController < ApplicationController
  admin_requirements      :manage_projects
  team_requirements       :manage_tickets
  before_filter           :require_project_admin, only: [ :new, :create, :edit, :update, :destroy ]
  before_filter           :require_public,        only: [ :index, :show ]

  before_filter           :load_project
  before_filter           :load_milestone
  before_filter           :load_ticket,           only: [ :show, :edit, :update, :destroy ]

  # GET /projects/1/milestones/1/tickets
  # GET /projects/1/milestones/1/tickets.json
  def index
    @tickets = Ticket.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tickets }
    end
  end

  # GET /projects/1/milestones/1/tickets/1
  # GET /projects/1/milestones/1/tickets/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket }
    end
  end

  # GET /projects/1/milestones/1/tickets/new
  # GET /projects/1/milestones/1/tickets/new.json
  def new
    @ticket = Ticket.new
    @ticket.milestone_id |= @milestone.id

    prepare_select

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticket }
    end
  end

  # GET /projects/1/milestones/1/tickets/1/edit
  def edit
    prepare_select
  end

  # POST /projects/1/milestones/1/tickets
  # POST /projects/1/milestones/1/tickets.json
  def create
    @ticket = Ticket.new(params[:ticket])

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to project_milestone_ticket_path(@project.url_name, @milestone.id, @ticket.id), notice: 'Ticket was successfully created.' }
        format.json { render json: @ticket, status: :created, location: project_milestone_ticket_path(@project.url_name, @milestone.id, @ticket.id) }
      else
        prepare_select
        format.html { render action: "new" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1/milestones/1/tickets/1
  # PUT /projects/1/milestones/1/tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        format.html { redirect_to project_milestone_ticket_path(@project.url_name, @milestone.id, @ticket.id), notice: 'Ticket was successfully updated.' }
        format.json { head :ok }
      else
        prepare_select
        format.html { render action: "edit" }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1/milestones/1/tickets/1
  # DELETE /projects/1/milestones/1/tickets/1.json
  def destroy
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to project_milestone_tickets_path(@project.url_name, @milestone.id) }
      format.json { head :ok }
    end
  end

  private

  # pobiera projekt
  def load_project
    begin
      @project = Project.find_by_url params[:project_id]
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to(homepage_path, :notice => "#{$!}") }
        format.json { head :not_found }
      end
    end
  end

  # pobiera milestone
  def load_milestone
    begin
      @milestone = Milestone.find_by_id_and_project_id params[:milestone_id], @project.id
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to(project_path(@project.url_name), :notice => "#{$!}") }
        format.json { head :not_found }
      end
    end
  end

  # pobiera ticket
  def load_ticket
    begin
      @ticket = Ticket.find_by_id_and_milestone_id params[:id], params[:milestone_id]
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to(project_milestone_path(@project.url_name, @milestone.id), :notice => "#{$!}") }
        format.json { head :not_found }
      end
    end
  end

  def prepare_select
    @select_user = []
    @project.users.each { |user| @select_user << [user.name+(user.id.eql?(current_user.id) ? " (me)" : ""), user.id] }

    @select_milestone = []
    @project.milestones.each { |milestone| @select_milestone << [milestone.name, milestone.id] }
  end
end